import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:codelabs_flutter/settings.dart';

class Product {
  int? id;
  String name;
  double? preis;
  String? pathToImage;
  int menge;

  Product(
      {required this.name,
      this.preis,
      this.pathToImage,
      required this.menge, int? id}) : this.id = id ?? null;

  double getPrice(){
    return double.parse(preis!.toStringAsFixed(2));
  }
  String getPriceString(){
    return preis!.toStringAsFixed(2);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'preis': preis,
      'menge': menge,
    };
  }


  static Future<void> addProdukt(Product product)async{
    final url = Uri.parse('${Settings.baseUrl}/Produkt');

    final headers = {'Content-Type': 'application/json'};
    final jsonBody = json.encode(product.toJson());
    final response = await http.post(url, headers: headers, body: jsonBody);

    if (response.statusCode == 201) {
      // Erfolgreiche Antwort
      final jsonResponse = json.decode(response.body);
      product.id = jsonResponse['id'] as int?;
    } else {
      // Fehlerhafte Antwort
      throw Exception('Fehler beim Senden des POST-Requests');
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      preis: json['preis'],
      menge: json['menge'],
    );
  }
  static Future<List<Product>> getProdukte() async {
    //TODO TESTING NOT DONE
    final response = await http.get(Uri.parse('${Settings.baseUrl}/Produkt'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      List<Product> produkte = [];
      for (var item in jsonData) {
        Product product = Product.fromJson(item);
        produkte.add(product);
      }

      return produkte;
    } else {
      throw Exception('Failed to load Contact Persons');
    }
  }

}
