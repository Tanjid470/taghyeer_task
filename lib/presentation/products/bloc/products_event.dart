import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProductsEvent extends ProductsEvent {}

class LoadMoreProductsEvent extends ProductsEvent {}

class RefreshProductsEvent extends ProductsEvent {}
