import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.thumbnail,
    required super.category,
    required super.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        thumbnail: json['thumbnail'] as String? ?? '',
        category: json['category'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      );
}
