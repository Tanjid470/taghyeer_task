import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../products/bloc/products_bloc.dart';
import '../../posts/bloc/posts_bloc.dart';
import '../../products/screens/products_screen.dart';
import '../../posts/screens/posts_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/get_posts_usecase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ProductsScreen(),
    PostsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsBloc>(
          create: (ctx) => ProductsBloc(ctx.read<GetProductsUseCase>()),
        ),
        BlocProvider<PostsBloc>(
          create: (ctx) => PostsBloc(ctx.read<GetPostsUseCase>()),
        ),
      ],
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) => setState(() => _currentIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag),
                label: 'Products',
              ),
              NavigationDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article),
                label: 'Posts',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
