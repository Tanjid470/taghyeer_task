import '../entities/post_entity.dart';
import '../repositories/posts_repository.dart';

class GetPostsUseCase {
  final PostsRepository repository;
  GetPostsUseCase(this.repository);

  Future<List<PostEntity>> call({required int skip, int limit = 10}) =>
      repository.getPosts(skip: skip, limit: limit);
}
