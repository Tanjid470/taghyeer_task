import 'package:equatable/equatable.dart';
import '../../../domain/entities/product_entity.dart';

abstract class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  final bool hasReachedMax;
  final bool isLoadingMore;

  ProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ProductsLoaded copyWith({
    List<ProductEntity>? products,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) =>
      ProductsLoaded(
        products: products ?? this.products,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );

  @override
  List<Object?> get props => [products, hasReachedMax, isLoadingMore];
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
