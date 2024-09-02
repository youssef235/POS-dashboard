import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String type;
  int amount;
  int soldAmount;
  final String? imageUrl;
  final DateTime createdAt; // Add the createdAt field

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.amount,
    required this.soldAmount,
    this.imageUrl,
    required this.createdAt, // Initialize the new field
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as double,
      type: json['type'] as String,
      amount: json['amount'] as int,
      soldAmount: json['soldAmount'] as int,
      imageUrl: json['imageUrl'] as String?,
      createdAt:
          (json['createdAt'] as Timestamp).toDate(), // Parse createdAt field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'type': type,
      'amount': amount,
      'soldAmount': soldAmount,
      'imageUrl': imageUrl,
      'createdAt': createdAt, // Include createdAt in JSON
    };
  }
}
