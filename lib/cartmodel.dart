class Cart{
  int id;
  String productId;
  String productName;
  int initialPrice;
  int productPrice;
  int quantity;
  String unitTag;
  String image;

  Cart({
    required this.id,
    required this.productId,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.unitTag,
    required this.image
  });

  Cart.fromMAp(Map<dynamic , dynamic> resources)
  : id = resources['id'],
  productId = resources['productId'],
  productName = resources['productName'],
  initialPrice = resources['initialPrice'],
  productPrice = resources['productPrice'],
  quantity = resources['quantity'],
  unitTag = resources['unitTag'],
  image = resources['image'];

  Map<String , Object?> toMap(){ 
    return{
      'id' : id,
      'productId' : productId,
      'productName' : productName,
      'initialPrice' : initialPrice,
      'productPrice' : productPrice,
      'quantity' : quantity,
      'unitTag' : unitTag,
      'image' : image    
    };
  }
}

