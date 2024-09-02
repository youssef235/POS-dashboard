import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/DashBoard/Cubit/product_state.dart';
import 'package:pos_app/DashBoard/Widgets/bottomNavigationBar.dart';
import 'package:pos_app/DashBoard/Widgets/textFieldAdd.dart';
import '../Cubit/product_cubit.dart';
import '../Models/product_model.dart';

class AddEditProductScreen extends StatelessWidget {
  final Product? product;

  AddEditProductScreen({this.product});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductCubit>();
    final _formKey = GlobalKey<FormState>();
    String _name = product?.name ?? '';
    double _price = product?.price ?? 0;
    String _type = product?.type ?? 'paid';
    int _amount = product?.amount ?? 0;
    int _soldAmount = product?.soldAmount ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product == null ? 'Add Product' : 'Edit Product',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[400], // لون هادئ للأب بار
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),

                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(blurRadius: 5, color: Colors.black12)
                        ],
                      ),
                      child: state is ProductImagePicked
                          ? kIsWeb
                              ? Image.memory(
                                  cubit.selectedImageBytes!,
                                  fit: BoxFit.fill,
                                )
                              : Image.file(
                                  cubit.selectedImage!,
                                  fit: BoxFit.cover,
                                )
                          : product?.imageUrl != null
                              ? Image.network(
                                  product!.imageUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Icon(Icons.image,
                                      color: Colors.grey[500], size: 50)),
                    ),
                  ),
                  SizedBox(height: 20),

                  buildAddTextFormField(
                    label: 'Product Name',
                    initialValue: _name,
                    onSaved: (value) => _name = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  buildAddTextFormField(
                    label: 'Price',
                    initialValue: _price.toString(),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _price = double.parse(value!),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a price' : null,
                  ),
                  buildAddTextFormField(
                    label: 'Amount',
                    initialValue: _amount.toString(),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _amount = int.parse(value!),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter an amount' : null,
                  ),
                  buildAddTextFormField(
                    label: 'Sold Amount',
                    initialValue: _soldAmount.toString(),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _soldAmount = int.parse(value!),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter sold amount' : null,
                  ),

                  SizedBox(height: 20),

                  // Pick Image Button
                  ElevatedButton(
                    onPressed: () async {
                      await cubit.pickImage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[300], // لون هادئ للأزرار
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Pick Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final newProduct = Product(
                          id: product?.id ?? '',
                          name: _name,
                          price: _price,
                          type: _type,
                          amount: _amount,
                          soldAmount: _soldAmount,
                          imageUrl: product?.imageUrl ?? '',
                          createdAt: product?.createdAt ?? DateTime.now(),
                        );

                        await cubit.saveProduct(newProduct);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      product == null ? 'Add Product' : 'Update Product',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: buildBottomAppBar(context),
    );
  }
}
