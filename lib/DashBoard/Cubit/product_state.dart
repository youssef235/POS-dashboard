import 'package:equatable/equatable.dart';
import '../Models/product_model.dart';

abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> allProducts;
  final List<Product> paidProducts;
  final List<Product> stillProducts;
  final double totalIncome;
  final double totalSales;
  final int totalTransactions;

  ProductLoaded(this.allProducts, this.paidProducts, this.stillProducts,
      this.totalIncome, this.totalSales, this.totalTransactions);

  @override
  List<Object> get props => [
        allProducts,
        paidProducts,
        stillProducts,
        totalIncome,
        totalSales,
        totalTransactions
      ];
}

class ProductImagePicked extends ProductState {}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

  @override
  List<Object> get props => [message];
}

class SoldProductsLoaded extends ProductState {
  final List<Product> productsSoldToday;
  final List<Product> productsSoldThisMonth;
  final double totalIncomeToday;
  final double totalIncomeThisMonth;

  SoldProductsLoaded({
    required this.productsSoldToday,
    required this.productsSoldThisMonth,
    required this.totalIncomeToday,
    required this.totalIncomeThisMonth,
  });

  @override
  List<Object> get props => [
        productsSoldToday,
        productsSoldThisMonth,
        totalIncomeToday,
        totalIncomeThisMonth,
      ];
}
