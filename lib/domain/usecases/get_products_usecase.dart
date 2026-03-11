import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase {
  final ProductsRepository repository;
  GetProductsUseCase(this.repository);

  Future<List<ProductEntity>> call({required int skip, int limit = 10}) =>
      repository.getProducts(skip: skip, limit: limit);
}
