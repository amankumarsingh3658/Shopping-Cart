import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart/cartprovider.dart';
import 'package:shoppingcart/productlist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider(create: (_) => CartProvider(),
   child: Builder(builder: (context){
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Cart',
      home: const ProductListScreen(),
    );
   }),);
}
}