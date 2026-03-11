import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taghyeer_task/domain/entities/product_entity.dart';
import 'package:taghyeer_task/presentation/products/screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  const ProductCard({super.key, required this.product});

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
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  width: 92,
                  height: 92,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 92,
                    height: 92,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_outlined),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 92,
                    height: 92,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        product.category,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Colors.amber.shade600,
                        ),
                        const SizedBox(width: 2),
                        Text(product.rating.toStringAsFixed(1)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
