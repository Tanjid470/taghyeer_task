import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_datasource.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  PostsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PostEntity>> getPosts({
    required int skip,
    required int limit,
  }) =>
      remoteDataSource.getPosts(skip: skip, limit: limit);
}
