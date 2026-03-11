import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_task/presentation/posts/screens/widgets/post_card.dart';
import '../bloc/posts_bloc.dart';
import '../bloc/posts_event.dart';
import '../bloc/posts_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/empty_view.dart';
import '../../../domain/entities/post_entity.dart';
import 'post_detail_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(LoadPostsEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 220) {
      context.read<PostsBloc>().add(LoadMorePostsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Posts',     style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),),
            Text(
              'Latest updates from the community',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostsError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<PostsBloc>().add(LoadPostsEvent()),
            );
          }
          if (state is PostsLoaded) {
            if (state.posts.isEmpty) {
              return const EmptyView(message: 'No posts found');
            }
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<PostsBloc>().add(RefreshPostsEvent()),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 96),
                itemCount: state.posts.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.posts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return PostCard(post: state.posts[index]);
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

