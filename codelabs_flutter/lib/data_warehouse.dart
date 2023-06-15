import 'package:codelabs_flutter/product.dart';
import 'package:codelabs_flutter/schulden_objekt.dart';

import 'kasse.dart';
import 'kunde.dart';

class DataWarehouse {

  static List<Kunde> kunden = [];
  static List<Product> sortiment = [];

  static Kunde? kunde;
  static Kunde? kassen_kunde;
  static List<Product> current_produkte = [];

  static void refresh() {
    web_act_get_kunden();
    web_act_get_products();
  }

  static void addProductToSortiment(name, price, pathToImage, initialAmount) {
    var product = Product(
        name: name,
        pathToImage: pathToImage,
        preis: price,
        menge: initialAmount,
        id: null);
    sortiment.add(product);
    Product.addProdukt(product);
  }

  static void addKunde(vorname, nachname, saldo) {
    Kunde kunde = Kunde(vorname: vorname, nachname: nachname, budget: saldo);
    kunden.add(kunde);
    Kunde.addKunde(kunde);
  }

  static void addCosts(products_i, products_n) {
    for (var i in products_i) {
      var j = products_n[products_i.indexOf(i)];
      while (j > 0) {
        kunde?.addSchuldenObjekt(i);
        j--;
      }
    }
  }

  static void schuldenObjektBezahlt(SchuldenObjekt so) {
    so.schuldenObjektBezahlt();
    Kasse.addSaldo(so.product.getPrice());
  }

  static void bezahleAlleSchulden() {
    for (SchuldenObjekt s in kassen_kunde!.schulden_objekte!.where((SchuldenObjekt e) => !e.bezahlt!)) {
      schuldenObjektBezahlt(s);
    }
  }

  static void bezahleAlleSchuldenDirekt() {
    for (SchuldenObjekt s in kunde!.schulden_objekte!.where((SchuldenObjekt e) => !e.bezahlt!)) {
      schuldenObjektBezahlt(s);
    }
  }
  static void entferneSchuldenObjekt(SchuldenObjekt so){
    kassen_kunde?.entferneSchuldenObjekt(so);
  }

  static void updateKunde(k) {
    kunde = k;
  }
  static void updateKassenKunde(k) {
    kassen_kunde = k;
  }

  static void updateProdukte(p) {
    current_produkte.add(p);
  }
  static void clearCurrentProdukte() {
    current_produkte = [];
  }
  static void reduce_menge(Product product){
    product.menge -= 1;
  }

  static void clear_kunde(){
    kunde = null;
  }

  static void clear_kassen_kunde(){
    kassen_kunde = null;
  }

  static void web_act_get_kunden(){
    Kunde.getKunden().then((value) => {
      kunden = value
    });
  }

  static void web_act_get_products(){
    Product.getProdukte().then((value) => {
      sortiment = value
    });
  }
}