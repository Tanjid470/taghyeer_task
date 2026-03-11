import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/usecases/get_posts_usecase.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase getPostsUseCase;
  int _currentSkip = 0;

  PostsBloc(this.getPostsUseCase) : super(PostsInitial()) {
    on<LoadPostsEvent>(_onLoad);
    on<LoadMorePostsEvent>(_onLoadMore);
    on<RefreshPostsEvent>(_onRefresh);
  }

  Future<void> _onLoad(
    LoadPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostsLoading());
    try {
      _currentSkip = 0;
      final posts = await getPostsUseCase(
        skip: 0,
        limit: ApiConstants.pageLimit,
      );
      _currentSkip = posts.length;
      emit(PostsLoaded(
        posts: posts,
        hasReachedMax: posts.length < ApiConstants.pageLimit,
      ));
    } on NetworkFailure catch (e) {
      emit(PostsError(e.message));
    } on ServerFailure catch (e) {
      emit(PostsError(e.message));
    } catch (_) {
      emit(PostsError('Failed to load posts'));
    }
  }

  Future<void> _onLoadMore(
    LoadMorePostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is! PostsLoaded ||
        current.hasReachedMax ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final newPosts = await getPostsUseCase(
        skip: _currentSkip,
        limit: ApiConstants.pageLimit,
      );
      _currentSkip += newPosts.length;
      emit(PostsLoaded(
        posts: [...current.posts, ...newPosts],
        hasReachedMax: newPosts.length < ApiConstants.pageLimit,
      ));
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefresh(
    RefreshPostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    _currentSkip = 0;
    add(LoadPostsEvent());
  }
}
