import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/DashBoard/Cubit/product_cubit.dart';
import 'package:pos_app/DashBoard/Cubit/product_state.dart';
import 'package:pos_app/DashBoard/Models/product_model.dart';
import 'package:pos_app/DashBoard/Widgets/bottomNavigationBar.dart';

class SoldProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<ProductCubit>().fetchSoldProductsForPeriod();

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        Widget body;

        if (state is ProductLoading) {
          body = Center(child: CircularProgressIndicator());
        } else if (state is SoldProductsLoaded) {
          body = Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildSection(
                  context,
                  "Today's Sales",
                  state.productsSoldToday,
                  state.totalIncomeToday,
                  Icons.today,
                ),
                SizedBox(height: 16),
                _buildSection(
                  context,
                  "This Month's Sales",
                  state.productsSoldThisMonth,
                  state.totalIncomeThisMonth,
                  Icons.calendar_month,
                ),
              ],
            ),
          );
        } else if (state is ProductError) {
          body = Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        } else {
          body = Center(
            child: Text('No Data Available', style: TextStyle(fontSize: 16)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Sold Products',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.blueGrey[400],
          ),
          body: body,
          bottomNavigationBar: buildBottomAppBar(context),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title,
      List<Product> products, double totalIncome, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueGrey[700]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.blueGrey[300]),
            SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    title: Text(product.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Sold: ${product.soldAmount}, Price: \$${product.price}',
                      style: TextStyle(color: Colors.blueGrey[600]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Total Income: \$${totalIncome.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
