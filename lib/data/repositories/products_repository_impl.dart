import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;
  ProductsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getProducts({
    required int skip,
    required int limit,
  }) =>
      remoteDataSource.getProducts(skip: skip, limit: limit);
}
