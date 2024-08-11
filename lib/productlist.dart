import 'dart:ffi';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart/cartmodel.dart';
import 'package:shoppingcart/cartprovider.dart';
import 'package:shoppingcart/cartscreen.dart';
import 'package:shoppingcart/databasehelper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper? dbhelper = DBHelper();
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Cherry',
    'Peach',
    'Mixed Fruit Basket'
  ];
  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG'];
  List<int> productPrice = [
    10,
    20,
    30,
    40,
    50,
    60,
    70,
  ];
  List<String> productImage = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxSSIwnEAeVUK6wPUwZuuS4330ZpsfChPBSqc6P5zUzvYjGz2JFvSDT955HA&s',
    'https://img.freepik.com/free-photo/delicious-mandarin_144627-27550.jpg?size=626&ext=jpg',
    'https://thumbs.dreamstime.com/b/white-grapes-background-84253637.jpg?w=768',
    'https://t3.ftcdn.net/jpg/00/09/08/54/240_F_9085486_EE5ha1cNDfYgSc23pWXLTwjyX0pP5zV9.jpg',
    'https://t4.ftcdn.net/jpg/00/67/54/07/240_F_67540718_WemW07iRXmGAvJ9A3E0tLlJx5GxxpRwC.jpg',
    'https://media.istockphoto.com/id/1488579837/photo/peach-fruit-isolated-on-white-background-three-peach-fruits-whole-and-cut-pieces.webp?b=1&s=170667a&w=0&k=20&c=4V_YvjRV6xuvZtBZslChto9heLKwE8z74Ar3nPpFeC0=',
    'https://media.istockphoto.com/id/810147810/photo/fruit-bowl-isolated.jpg?s=612x612&w=0&k=20&c=F2zDR2U5EHDK_FUWGjE3mkhTHuZlupmMHsl1kLLjSJg='
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Products List"),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                    value.getCounterValue().toString(),
                    style: TextStyle(color: Colors.white),
                  );
                  },
                  
                ),
                badgeAnimation: badges.BadgeAnimation.fade(),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20)
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                  height: 100,
                                  width: 100,
                                  image: NetworkImage(
                                      productImage[index].toString())),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      productName[index].toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      productUnit[index].toString() +
                                          " " +
                                          '₹' +
                                          productPrice[index].toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: (){
                                          dbhelper!.insert(
                                            Cart(
                                              id: index,
                                              productId: index.toString(),
                                              productName: productName[index].toString(),
                                              initialPrice: productPrice[index],
                                               productPrice: productPrice[index],
                                               quantity: 1,
                                               unitTag: productUnit[index].toString(),
                                               image: productImage[index].toString())).then((value){
                                                cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                                cart.addCounter();
                                                print('Product is added to cart');
                                               }).onError((error, stackTrace){
                                                print(error.toString());
                                               });
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(color: Colors.teal,
                                          borderRadius: BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text("Add To Cart",style: TextStyle(color: Colors.white),),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}


