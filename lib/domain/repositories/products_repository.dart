import '../entities/product_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProducts({required int skip, required int limit});
}
