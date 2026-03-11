import 'package:flutter/material.dart';
import '../../../domain/entities/post_entity.dart';

class PostDetailScreen extends StatelessWidget {
  final PostEntity post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    _StatItem(
                        icon: Icons.visibility_outlined, text: '${post.views} views'),
                    const SizedBox(width: 12),
                    _StatItem(
                        icon: Icons.thumb_up_alt_outlined,
                        text: '${post.likes} likes'),
                    const SizedBox(width: 12),
                    _StatItem(
                        icon: Icons.thumb_down_alt_outlined,
                        text: '${post.dislikes}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(tag, style: theme.textTheme.labelSmall),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  post.body,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _StatItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
