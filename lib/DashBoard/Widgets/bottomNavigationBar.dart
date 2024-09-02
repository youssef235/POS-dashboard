import 'package:flutter/material.dart';
import 'package:pos_app/DashBoard/View/add_product_screen.dart';
import 'package:pos_app/DashBoard/View/product_analysis_screen.dart';
import 'package:pos_app/DashBoard/View/product_list_screen.dart';
import 'package:pos_app/DashBoard/View/users_screen.dart';

Widget buildBottomAppBar(context) {
  return BottomAppBar(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(Icons.bar_chart),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductAnalysisScreen()));
          },
          tooltip: 'View Analysis',
        ),
        IconButton(
          icon: Icon(Icons.production_quantity_limits),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductsScreen()));
          },
          tooltip: 'View Products',
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddEditProductScreen()));
          },
          tooltip: 'Add Product',
        ),
        IconButton(
          icon: Icon(Icons.people),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UsersScreen()));
          },
          tooltip: 'View Users',
        ),
      ],
    ),
  );
}
