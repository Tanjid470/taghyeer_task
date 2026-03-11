import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPostsEvent extends PostsEvent {}

class LoadMorePostsEvent extends PostsEvent {}

class RefreshPostsEvent extends PostsEvent {}
