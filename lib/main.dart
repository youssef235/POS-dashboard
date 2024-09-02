import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/DashBoard/View/product_analysis_screen.dart';
import 'DashBoard/Cubit/product_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDW-F4p9pbBVfdliPYz2Qx4Z0Bqk3_G-NA",
        authDomain: "posapp-b998e.firebaseapp.com",
        projectId: "posapp-b998e",
        storageBucket: "posapp-b998e.appspot.com",
        messagingSenderId: "516403164987",
        appId: "1:516403164987:web:37a5bd7697076e6fdae91e",
        measurementId: "G-6BF05KCSX6"),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductCubit(FirebaseFirestore.instance),
        ),
      ],
      child: MaterialApp(
        title: 'Product App',
        home: ProductAnalysisScreen(),
      ),
    );
  }
}
