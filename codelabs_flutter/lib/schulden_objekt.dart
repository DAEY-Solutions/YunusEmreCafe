import 'dart:convert';

import 'package:codelabs_flutter/product.dart';
import 'package:codelabs_flutter/settings.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SchuldenObjekt{
  int? id;
  Product product;
  bool? bezahlt;
  DateTime? when;

  SchuldenObjekt({
    this.id, required this.product,bool? bezahlt, DateTime? when,
}) : this.when = when ?? DateTime.now(),
      this.bezahlt = bezahlt ?? false;

  String getWhen(){
    /*DateFormat formatter_default = DateFormat('dd.MM.yyyy HH:mm');
    DateFormat formatter_today = DateFormat('HH:mm');
    if (when.difference(DateTime.now()).inDays == 0){
      return "heute ${formatter_today.format(when)}";
    } else if (when.difference(DateTime.now()).inDays == 1){
      return "gestern ${formatter_today.format(when)}";
    } else if (when.difference(DateTime.now()).inDays == 2){
      return "vorgestern ${formatter_default.format(when)}";
    }*/
    return "${when?.day}.${when?.month}.${when?.year} ${when?.hour.toString()}:${when?.minute.toString()}";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produkt': product.toJson(),
      'bezahlt': bezahlt,
      'whenn': DateFormat('yyyy-MM-dd HH:mm:ss').format(when!),
    };
  }
  factory SchuldenObjekt.fromJson(Map<String, dynamic> json) {
    return SchuldenObjekt(
      id: json['id'],
      product: Product.fromJson(json['produkt']),
      when: DateFormat('yyyy-MM-dd HH:mm:ss').parse(json['whenn']),
      bezahlt: json['bezahlt'],
    );
  }

  Future<void> schuldenObjektBezahlt()async{

    final url = Uri.parse('${Settings.baseUrl}/SchuldenObjekt');

    final headers = {'Content-Type': 'application/json'};
    final jsonBody = json.encode(this.toJson());
    final response = await http.put(url, headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      // Erfolgreiche Antwort
      // final jsonResponse = json.decode(response.body);
      // print(jsonResponse);
      // this.id = jsonResponse['id'] as int?;
      // return jsonResponse;
    } else {
      // Fehlerhafte Antwort
      throw Exception('Fehler beim Senden des POST-Requests');
    }
    this.bezahlt = true;
  }
}