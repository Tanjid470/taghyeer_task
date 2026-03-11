import 'package:equatable/equatable.dart';
import '../../../domain/entities/post_entity.dart';

abstract class PostsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<PostEntity> posts;
  final bool hasReachedMax;
  final bool isLoadingMore;

  PostsLoaded({
    required this.posts,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  PostsLoaded copyWith({
    List<PostEntity>? posts,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) =>
      PostsLoaded(
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );

  @override
  List<Object?> get props => [posts, hasReachedMax, isLoadingMore];
}

class PostsError extends PostsState {
  final String message;
  PostsError(this.message);

  @override
  List<Object?> get props => [message];
}
