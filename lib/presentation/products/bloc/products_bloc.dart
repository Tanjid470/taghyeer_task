import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  int _currentSkip = 0;

  ProductsBloc(this.getProductsUseCase) : super(ProductsInitial()) {
    on<LoadProductsEvent>(_onLoad);
    on<LoadMoreProductsEvent>(_onLoadMore);
    on<RefreshProductsEvent>(_onRefresh);
  }

  Future<void> _onLoad(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      _currentSkip = 0;
      final products = await getProductsUseCase(
        skip: 0,
        limit: ApiConstants.pageLimit,
      );
      _currentSkip = products.length;
      emit(ProductsLoaded(
        products: products,
        hasReachedMax: products.length < ApiConstants.pageLimit,
      ));
    } on NetworkFailure catch (e) {
      emit(ProductsError(e.message));
    } on ServerFailure catch (e) {
      emit(ProductsError(e.message));
    } catch (_) {
      emit(ProductsError('Failed to load products'));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    final current = state;
    if (current is! ProductsLoaded ||
        current.hasReachedMax ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final newProducts = await getProductsUseCase(
        skip: _currentSkip,
        limit: ApiConstants.pageLimit,
      );
      _currentSkip += newProducts.length;
      emit(ProductsLoaded(
        products: [...current.products, ...newProducts],
        hasReachedMax: newProducts.length < ApiConstants.pageLimit,
      ));
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefresh(
    RefreshProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    _currentSkip = 0;
    add(LoadProductsEvent());
  }
}
