import 'package:flutter/material.dart';
import 'package:pos_app/DashBoard/Cubit/product_cubit.dart';
import '../Models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildProductList(List<Product> products, BuildContext context) {
  return ListView.builder(
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];
      int currentAmount = product.amount;
      int soldAmount = product.soldAmount;

      return StatefulBuilder(
        builder: (context, setState) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (product.imageUrl != null)
                    Image.network(
                      product.imageUrl!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      height: 100,
                      width: 100,
                      color: Colors.grey,
                      child: Center(
                        child: Text(
                          'No Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Amount: $currentAmount'),
                            SizedBox(width: 16),
                            Text('Sold: ${product.soldAmount}'),
                            SizedBox(width: 16),
                            Text(
                                'Remaining: ${currentAmount - product.soldAmount}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (currentAmount > 0) {
                                setState(() {
                                  currentAmount--;
                                  soldAmount++;
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                currentAmount++;
                              });
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Save the updated product amount to Firebase
                          product.amount = currentAmount;
                          product.soldAmount =
                              soldAmount; // Update the product amount
                          context.read<ProductCubit>().updateProduct(product);
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
