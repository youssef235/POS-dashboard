import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/DashBoard/Cubit/product_cubit.dart';
import 'package:pos_app/DashBoard/Cubit/product_state.dart';
import 'package:pos_app/DashBoard/Widgets/bottomNavigationBar.dart';
import '../widgets/search_field.dart';
import '../widgets/buildProductList.dart'; // Assuming this widget is in a separate file.

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return BlocProvider(
      create: (context) => ProductCubit(firestore)..fetchProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Products',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueGrey[400],
        ),
        body: Column(
          children: [
            SearchField(),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    final products = state.allProducts;
                    return buildProductList(products, context);
                  } else if (state is ProductError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return Center(child: Text('No products found.'));
                  }
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: buildBottomAppBar(context),
      ),
    );
  }
}
