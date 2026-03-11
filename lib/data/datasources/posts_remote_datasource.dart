import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/post_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getPosts({required int skip, required int limit});
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final ApiClient apiClient;
  PostsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<PostModel>> getPosts({
    required int skip,
    required int limit,
  }) async {
    final response = await apiClient.get(
      '${ApiConstants.postsUrl}?limit=$limit&skip=$skip',
    );
    final posts = response['posts'] as List;
    return posts
        .map((p) => PostModel.fromJson(p as Map<String, dynamic>))
        .toList();
  }
}
