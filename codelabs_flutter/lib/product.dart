class Product {
  String name;
  double? preis;
  String pathToImage;
  int menge;

  Product(
      {required this.name,
      this.preis,
      required this.pathToImage,
      required this.menge});

  double getPrice(){
    return double.parse(preis!.toStringAsFixed(2));
  }
  String getPriceString(){
    return preis!.toStringAsFixed(2);
  }
}
