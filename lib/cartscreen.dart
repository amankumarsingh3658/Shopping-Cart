import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingcart/cartmodel.dart';
import 'package:shoppingcart/cartprovider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shoppingcart/databasehelper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
          centerTitle: true,
          actions: [
            Center(
                child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(value.getCounterValue().toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500));
                },
              ),
              badgeAnimation: badges.BadgeAnimation.fade(),
              child: Icon(Icons.shopping_bag_outlined),
            )),
            SizedBox(width: 20)
          ],
        ),
        body: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image(
                                            height: 100,
                                            width: 100,
                                            image: NetworkImage(
                                                snapshot.data![index].image)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data![index].productName
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      dbHelper!.delete(snapshot
                                                          .data![index].id);
                                                      cart.removeCounter();
                                                      cart.removeTotalPrice(
                                                          double.parse(snapshot
                                                              .data![index]
                                                              .productPrice
                                                              .toString()));
                                                    },
                                                    child: Icon(Icons.delete))
                                              ],
                                            ),
                                            // Text(
                                            //   snapshot.data![index].productName
                                            //       .toString(),
                                            //   style: TextStyle(
                                            //       fontSize: 16,
                                            //       fontWeight: FontWeight.w500),
                                            // ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              snapshot.data![index].unitTag
                                                      .toString() +
                                                  " " +
                                                  "₹" +
                                                  snapshot
                                                      .data![index].productPrice
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.teal),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    int quantity = snapshot.data![index].quantity;
                                                    int price = snapshot.data![index].initialPrice;
                                                    quantity --;
                                                    int newPrice = price * quantity;
                                                    if (quantity > 0) {                                                    
                                                    dbHelper!.updateQuantity(
                                                      Cart(id: snapshot.data![index].id,
                                                       productId: snapshot.data![index].productId,
                                                        productName: snapshot.data![index].productName, 
                                                        initialPrice: snapshot.data![index].initialPrice, 
                                                        productPrice: newPrice, 
                                                        quantity: quantity, 
                                                        unitTag: snapshot.data![index].unitTag.toString(), 
                                                        image: snapshot.data![index].image.toString())
                                                    ).then((value){
                                                      newPrice = 0;
                                                      quantity = 0;
                                                      cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                    }).onError((error, stackTrace){
                                                      print(error.toString());
                                                    });
                                                  };},
                                                  child: Icon(Icons.remove,color: Colors.white,)),
                                                Text(snapshot.data![index].quantity.toString(),style: TextStyle(fontSize: 16,color: Colors.white)),
                                                InkWell(
                                                  onTap: (){
                                                    int quantity = snapshot.data![index].quantity;
                                                    int price = snapshot.data![index].initialPrice;
                                                    quantity ++;
                                                    int newPrice = price * quantity;

                                                    dbHelper!.updateQuantity(
                                                      Cart(id: snapshot.data![index].id,
                                                       productId: snapshot.data![index].productId,
                                                        productName: snapshot.data![index].productName, 
                                                        initialPrice: snapshot.data![index].initialPrice, 
                                                        productPrice: newPrice, 
                                                        quantity: quantity, 
                                                        unitTag: snapshot.data![index].unitTag.toString(), 
                                                        image: snapshot.data![index].image.toString())
                                                    ).then((value){
                                                      newPrice = 0;
                                                      quantity = 0;
                                                      cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                    }).onError((error, stackTrace){
                                                      print(error.toString());
                                                    });
                                                  },
                                                  child: Icon(Icons.add,color: Colors.white,))
                                              ],
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ));
                            }));
                  } else {
                    return Text("");
                  }
                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                    ? false
                    : true,
                child: Column(
                  children: [
                    ReusableWidget(
                        title: "SubTotal",
                        value: '₹' + value.getTotalPrice().toString())
                  ],
                ),
              );
            })
          ],
        ));
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
