import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_task/presentation/products/screens/widgets/product_card.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../../widgets/error_view.dart';
import '../../widgets/empty_view.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(LoadProductsEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 220) {
      context.read<ProductsBloc>().add(LoadMoreProductsEvent());
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
            const Text('Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Browse curated inventory',

              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),

            ),
          ],
        ),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductsError) {
            return ErrorView(
              message: state.message,
              onRetry: () => context.read<ProductsBloc>().add(LoadProductsEvent()),
            );
          }
          if (state is ProductsLoaded) {
            if (state.products.isEmpty) {
              return const EmptyView(message: 'No products found');
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<ProductsBloc>().add(RefreshProductsEvent()),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 96),
                itemCount: state.products.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.products.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return ProductCard(product: state.products[index]);
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
