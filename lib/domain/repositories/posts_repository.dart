import '../entities/post_entity.dart';

abstract class PostsRepository {
  Future<List<PostEntity>> getPosts({required int skip, required int limit});
}
