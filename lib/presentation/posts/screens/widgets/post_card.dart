import 'package:flutter/material.dart';
import 'package:taghyeer_task/domain/entities/post_entity.dart';
import 'package:taghyeer_task/presentation/posts/screens/post_detail_screen.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 1,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: post.tags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      tag,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.visibility_outlined, size: 16,
                      color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${post.views}'),
                  const SizedBox(width: 16),
                  Icon(Icons.thumb_up_alt_outlined, size: 16,
                      color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${post.likes}'),
                  const Spacer(),
                  Icon(Icons.arrow_forward_rounded, size: 18,
                      color: theme.colorScheme.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
