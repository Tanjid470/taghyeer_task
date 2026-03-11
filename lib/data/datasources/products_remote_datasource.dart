import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<List<ProductModel>> getProducts({required int skip, required int limit});
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final ApiClient apiClient;
  ProductsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getProducts({
    required int skip,
    required int limit,
  }) async {
    final response = await apiClient.get(
      '${ApiConstants.productsUrl}?limit=$limit&skip=$skip',
    );
    final products = response['products'] as List;
    return products
        .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
        .toList();
  }
}
