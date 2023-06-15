import 'dart:convert';
import 'dart:io';

import 'package:codelabs_flutter/schulden_objekt.dart';
import 'package:codelabs_flutter/settings.dart';
import 'package:http/http.dart' as http;

class Kunde {
  int? id;
  String vorname;
  String nachname;
  double? _saldo;
  double budget;
  List<SchuldenObjekt>? schulden_objekte;


  Kunde({this.id, required this.vorname, required this.nachname, required this.budget, schulden_objekte})
  : this.schulden_objekte = schulden_objekte ?? [];

  String getFullname(){
    return "${vorname} ${nachname}";
  }

  void addSaldo(double add){
    budget = (budget + add);
  }

  void addSchuldenObjekt(produkt){
    SchuldenObjekt so = SchuldenObjekt(product: produkt);
    schulden_objekte?.add(so);
    webAddSchuldenobjekt(so);//.then((value) => {waitt = false});
    produkt.menge -= 1;
  }
  void _refreshSaldo(){
    double schulden = 0;
    for (var i in schulden_objekte!){
      if (!i.bezahlt!){
        schulden = schulden + double.parse(i.product.getPrice().toString());
      }
    }
    _saldo = budget - schulden;
  }
  double getSaldo(){
    _refreshSaldo();
    return _saldo!;
  }
  void entferneSchuldenObjekt(SchuldenObjekt so){
    so.product.menge += 1;
    schulden_objekte?.remove(so);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id != null ? id : null,
      'vorname': vorname,
      'nachname': nachname,
      'schuldenObjekte': schulden_objekte?.map((SchuldenObjekt e) => e.toJson()).toList(),
      'saldo': getSaldo(),
    };
  }
  factory Kunde.fromJson(Map<String, dynamic> json) {

    return Kunde(
      id: json['id'],
      vorname: json['vorname'],
      nachname: json['nachname'],
      budget: json['saldo'],
      schulden_objekte: (json['schuldenObjekte'] != null
          ? (json['schuldenObjekte'] as List<dynamic>)
          .map((e) => SchuldenObjekt.fromJson(e as Map<String, dynamic>))
          .toList()
          : []) as List<SchuldenObjekt>,
    );
  }


  Future<void> webAddSchuldenobjekt(SchuldenObjekt so)async{
    final url = Uri.parse('${Settings.baseUrl}/Kunde/${id}');
    final headers = {'Content-Type': 'application/json'};
    final jsonBody = json.encode(so.toJson());
    print("ANFRAGE: POST /Kunde/{${id}}");
    print("body: ${jsonBody}");
    print("");
    final response = await http.post(url, headers:headers, body: jsonBody);

    if (response.statusCode == 201) {
      print("ERFOLGREICH");
      print("Response-Code: ${response.statusCode}");
      print("Response-Body: ${response.body}");
      print("");
      final jsonResponse = json.decode(response.body);
      so.id = jsonResponse['id'] as int?;
    } else {
      print("FEHLGESCHLAGEN");
      print("Response-Code: ${response.statusCode}");
      print("Response-Body: ${response.body}");
      print("Wird erneut probiert.");
      print("");
      webAddSchuldenobjekt(so);

      // throw Exception('Fehler beim Senden des POST-Requests');
    }
  }

  static Future<void> addKunde(Kunde kunde)async{
    final url = Uri.parse('${Settings.baseUrl}/Kunde');

    final headers = {'Content-Type': 'application/json'};
    final jsonBody = json.encode(kunde.toJson());
    // print(jsonBody);
    final response = await http.post(url, headers: headers, body: jsonBody);


    if (response.statusCode == 201) {
      // Erfolgreiche Antwort
      final jsonResponse = json.decode(response.body);
      //print(jsonResponse);
      kunde.id = jsonResponse['id'] as int?;
      //return jsonResponse;
    } else {
      // Fehlerhafte Antwort
      throw Exception('Fehler beim Senden des POST-Requests');
    }
  }

  static Future<List<Kunde>> getKunden() async {
    //TODO TESTING NOT DONE
    final response = await http.get(Uri.parse('${Settings.baseUrl}/Kunde'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      List<Kunde> kunden = [];
      for (var item in jsonData) {
        Kunde kunde = Kunde.fromJson(item);
        kunden.add(kunde);
      }

      return kunden;
    } else {
      throw Exception('Failed to load Contact Persons');
    }
  }
}
