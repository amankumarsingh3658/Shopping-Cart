import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingcart/cartmodel.dart';
import 'package:shoppingcart/databasehelper.dart';

class CartProvider with ChangeNotifier{

  DBHelper? db = DBHelper();
  
  int _counter = 0;
  int get counter => _counter;

  double _totalprice = 0.0;
  double get totalprice => _totalprice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getData(){
    _cart =  db!.getCartList();
    return _cart;
  }

 void _setPrefItems() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('cart_items', _counter);
  prefs.setDouble('total_price', _totalprice);
  notifyListeners();
 }
 void _getPrefItems() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _counter = prefs.getInt('cart_items') ?? 0;
  _totalprice = prefs.getDouble('total_price') ?? 0;
  notifyListeners();
 }

 void addCounter(){
  _counter++;
  _setPrefItems();
  notifyListeners();
 }

 void removeCounter(){
  _counter--;
  _setPrefItems();
  notifyListeners();
 }
 int getCounterValue(){
  _getPrefItems();
  return _counter;
 }

 void addTotalPrice(double productPrice){
  _totalprice = _totalprice + productPrice;
  _setPrefItems();
  notifyListeners();
 }
 void removeTotalPrice(double productPrice){
  _totalprice = _totalprice - productPrice;
  _setPrefItems();
  notifyListeners();
 }
 double getTotalPrice(){
  _getPrefItems();
  return _totalprice;
  }
}