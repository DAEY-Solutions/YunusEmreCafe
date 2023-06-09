import 'package:codelabs_flutter/product.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbol_data_http_request.dart';
import 'package:intl/intl.dart';

class SchuldenObjekt{
  Product product;
  bool bezahlt = false;
  final DateTime when = DateTime.now();

  SchuldenObjekt({
    required this.product,
});

  String getWhen(){
    DateFormat formatter_default = DateFormat('dd.MM.yyyy HH:mm');
    DateFormat formatter_today = DateFormat('HH:mm');
    if (when.difference(DateTime.now()).inDays == 0){
      return "heute ${formatter_today.format(when)}";
    } else if (when.difference(DateTime.now()).inDays == 1){
      return "gestern ${formatter_today.format(when)}";
    } else if (when.difference(DateTime.now()).inDays == 2){
      return "vorgestern ${formatter_default.format(when)}";
    }
    return "${when.day}.${when.month}.${when.year} ${when.hour}:${when.minute}";
  }

}