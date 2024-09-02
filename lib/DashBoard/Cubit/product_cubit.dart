import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/product_model.dart';
import 'product_state.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProductCubit extends Cubit<ProductState> {
  final FirebaseFirestore firestore;
  String searchQuery = '';
  List<Product> _allProducts = [];
  Uint8List? selectedImageBytes;
  File? selectedImage;

  ProductCubit(this.firestore) : super(ProductInitial());

// New function to fetch sold products for today and this month
  Future<void> fetchSoldProductsForPeriod() async {
    emit(ProductLoading());
    try {
      final snapshot = await firestore.collection('products').get();
      final allProducts = snapshot.docs.map((doc) {
        return Product.fromJson({...doc.data(), 'id': doc.id});
      }).toList();

      final productsSoldToday = _filterProductsByDateRange(
          allProducts,
          DateTime.now().subtract(Duration(
              hours: DateTime.now().hour,
              minutes: DateTime.now().minute,
              seconds: DateTime.now().second)),
          DateTime.now());

      final firstDayOfMonth =
          DateTime(DateTime.now().year, DateTime.now().month, 1);
      final productsSoldThisMonth = _filterProductsByDateRange(
          allProducts, firstDayOfMonth, DateTime.now());

      // حساب الدخل الإجمالي
      final totalIncomeToday = _calculateTotalIncome(productsSoldToday);
      final totalIncomeThisMonth = _calculateTotalIncome(productsSoldThisMonth);

      emit(SoldProductsLoaded(
        productsSoldToday: productsSoldToday,
        productsSoldThisMonth: productsSoldThisMonth,
        totalIncomeToday: totalIncomeToday,
        totalIncomeThisMonth: totalIncomeThisMonth,
      ));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  List<Product> _filterProductsByDateRange(
      List<Product> products, DateTime start, DateTime end) {
    return products.where((product) {
      final createdAt = product.createdAt; // Assuming createdAt is a DateTime
      return createdAt.isAfter(start) && createdAt.isBefore(end);
    }).toList();
  }

  double _calculateTotalIncome(List<Product> products) {
    return products.fold(
        0, (sum, product) => sum + (product.price * product.soldAmount));
  }

  // 1. Data Loading
  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final snapshot = await firestore.collection('products').get();
      _allProducts = snapshot.docs.map((doc) {
        return Product.fromJson({...doc.data(), 'id': doc.id});
      }).toList();

      emit(_buildProductLoadedState(_allProducts));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  ProductLoaded _buildProductLoadedState(List<Product> products) {
    final totalIncome = calculateTotalIncome();
    final totalSales = calculateTotalSales();
    final totalTransactions = calculateTotalTransactions();

    return ProductLoaded(
      products,
      products.where((product) => product.type == 'paid').toList(),
      products.where((product) => product.type == 'still').toList(),
      totalIncome,
      totalSales,
      totalTransactions,
    );
  }

  double calculateTotalIncome() {
    return _allProducts.fold(
        0, (sum, product) => sum + (product.price * product.soldAmount));
  }

  double calculateTotalSales() {
    return _allProducts.fold(0, (sum, product) => sum + product.soldAmount);
  }

  int calculateTotalTransactions() {
    return _allProducts.length;
  }

  // 2. Search and Filter
  void searchProducts(String query) {
    searchQuery = query;
    emit(ProductLoading());

    final filteredProducts = _allProducts
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(_buildProductLoadedState(filteredProducts));
  }

  void clearSearch() {
    searchQuery = '';
    emit(ProductLoading());

    emit(_buildProductLoadedState(_allProducts));
  }

  // 3. Data Management
  Future<void> addProduct(Product product) async {
    try {
      await firestore.collection('products').add(product.toJson());
      await fetchProducts(); // Refresh data after adding
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await firestore
          .collection('products')
          .doc(product.id)
          .update(product.toJson());
      await fetchProducts(); // Refresh data after updating
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // 4. Image Handling
  Future<void> pickImage() async {
    if (kIsWeb) {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );

        if (result != null) {
          selectedImageBytes = result.files.single.bytes;
          emit(ProductImagePicked()); // Emit a state change
        } else {
          print('No image selected.');
        }
      } catch (e) {
        print("Failed to pick image: $e");
      }
    } else {
      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 90,
        );

        if (pickedFile != null) {
          selectedImage = File(pickedFile.path);
          emit(ProductImagePicked()); // Emit a state change
        } else {
          print('No image selected.');
        }
      } catch (e) {
        print("Failed to pick image: $e");
      }
    }
  }

  Future<String?> uploadImage() async {
    if (kIsWeb) {
      if (selectedImageBytes == null) return null;

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putData(selectedImageBytes!);
        final snapshot = await uploadTask.whenComplete(() {});
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print("Failed to upload image: $e");
        return null;
      }
    } else {
      if (selectedImage == null) return null;

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('product_images/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(selectedImage!);
        final snapshot = await uploadTask.whenComplete(() {});
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print("Failed to upload image: $e");
        return null;
      }
    }
  }

  Future<void> saveProduct(Product product) async {
    emit(ProductLoading());
    try {
      String? imageUrl;
      if (selectedImage != null || selectedImageBytes != null) {
        imageUrl = await uploadImage();
      } else {
        imageUrl = product.imageUrl;
      }

      final DateTime createdAt =
          product.id.isEmpty ? DateTime.now() : product.createdAt;

      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        price: product.price,
        type: product.type,
        amount: product.amount,
        soldAmount: product.soldAmount,
        imageUrl: imageUrl,
        createdAt: createdAt,
      );

      if (product.id.isEmpty) {
        await firestore.collection('products').add(updatedProduct.toJson());
      } else {
        await firestore
            .collection('products')
            .doc(product.id)
            .update(updatedProduct.toJson());
      }

      await fetchProducts();
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // 5. Accessors
  List<Product> getAllProducts() {
    final state = this.state;
    if (state is ProductLoaded) {
      return state.allProducts;
    }
    return [];
  }

  List<Product> getSoldProducts() {
    return getAllProducts().where((product) => product.soldAmount > 0).toList();
  }

  List<Product> getAvailableProducts() {
    return getAllProducts()
        .where((product) => product.amount > product.soldAmount)
        .toList();
  }
}
