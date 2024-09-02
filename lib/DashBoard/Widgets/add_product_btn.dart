import 'package:flutter/material.dart';
import 'package:pos_app/DashBoard/View/add_product_screen.dart';

Widget buildAddButton(context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AddEditProductScreen()),
      );
    },
    child: Icon(Icons.add),
    tooltip: 'Add Product',
  );
}
