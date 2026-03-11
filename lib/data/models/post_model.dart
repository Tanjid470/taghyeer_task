import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.userId,
    required super.tags,
    required super.views,
    required super.likes,
    required super.dislikes,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
        userId: json['userId'] as int,
        tags: List<String>.from(json['tags'] as List? ?? []),
        views: json['views'] as int? ?? 0,
        likes: (json['reactions'] as Map?)?['likes'] as int? ??
            json['likes'] as int? ??
            0,
        dislikes: (json['reactions'] as Map?)?['dislikes'] as int? ??
            json['dislikes'] as int? ??
            0,
      );
}
