import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/product_entity.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details'),centerTitle: true,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: product.thumbnail,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 260,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 260,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image_outlined, size: 64),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(product.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.6,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.category,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.star_rounded, size: 19, color: Colors.amber),
                const SizedBox(width: 2),
                Text('${product.rating.toStringAsFixed(1)} / 5'),
                const Spacer(),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
