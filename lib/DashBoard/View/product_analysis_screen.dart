import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/DashBoard/Cubit/product_cubit.dart';
import 'package:pos_app/DashBoard/Cubit/product_state.dart';
import 'package:pos_app/DashBoard/View/sold_products_screen.dart';
import 'package:pos_app/DashBoard/Widgets/bottomNavigationBar.dart';
import '../widgets/overview_card.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/visitor_chart.dart';
import '../widgets/order_tracking_chart.dart';

class ProductAnalysisScreen extends StatefulWidget {
  @override
  State<ProductAnalysisScreen> createState() => _ProductAnalysisScreenState();
}

class _ProductAnalysisScreenState extends State<ProductAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Analysis',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overview',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SoldProductsScreen(),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 24,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Click to view daily and monthly sales',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          BlocConsumer<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is ProductError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is ProductLoaded) {
                double totalIncome =
                    context.read<ProductCubit>().calculateTotalIncome();
                double totalSales =
                    context.read<ProductCubit>().calculateTotalSales();
                int totalTransactions =
                    context.read<ProductCubit>().calculateTotalTransactions();

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: OverviewCard(
                              title: 'Total Income',
                              amount: '\$${totalIncome.toStringAsFixed(2)}',
                              change: '+5% this month',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0), // مسافة بين البطاقات

                            child: OverviewCard(
                              title: 'Total Sales',
                              amount: '${totalSales.toString()}',
                              change: '+10% this month',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: OverviewCard(
                              title: 'Total Transactions',
                              amount: '${totalTransactions.toString()}',
                              change: '+3% this month',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Container(); // حالة افتراضية
            },
            listener: (BuildContext context, ProductState state) {},
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Total Revenue',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SizedBox(height: 200, child: RevenueChart()),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Our Visitor',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Container(height: 200, child: VisitorChart()),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Order Tracking',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Container(height: 200, child: OrderTrackingChart()),
              ],
            ),
          ),
        ])),
      ),
      bottomNavigationBar: buildBottomAppBar(context),
    );
  }
}
