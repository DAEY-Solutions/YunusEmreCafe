import 'package:codelabs_flutter/schulden_objekt.dart';

class Kunde {
  String vorname;
  String nachname;
  double? _saldo;
  double budget;
  List<SchuldenObjekt> schulden_objekte = [];


  Kunde({required this.vorname, required this.nachname, required this.budget});

  String getFullname(){
    return "${vorname} ${nachname}";
  }

  void addSaldo(double add){
    budget = (budget + add)!;
  }

  void addSchuldenObjekt(produkt){
    schulden_objekte.add(SchuldenObjekt(product: produkt));
    produkt.menge -= 1;
  }
  void _refreshSaldo(){
    double schulden = 0;
    for (var i in schulden_objekte){
      if (!i.bezahlt){
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
    schulden_objekte.remove(so);

  }
}
