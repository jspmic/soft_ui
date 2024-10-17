import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Transfert{
  late String date;
  late String plaque;
  late String logistic_official;
  late String numero_mouvement;
  late String district;
  late String stock_central_depart;
  late List<String?> stock_central_suivants = [];
  late String stock_central_retour;
  late String photo_mvt;
  late String type_transport;
  late String? motif;
  Transfert();
}

class Livraison{
  late String date;
  late String plaque;
  late String logistic_official;
  late String numero_mouvement;
  late String district;
  late String stock_central_depart;
  late Map<String, String> boucle = {};
  late String stock_central_retour;
  late String photo_mvt;
  late String type_transport;
  late String? motif;
  Livraison();
}

// Address definition
const String HOST = "https://jspemic.pythonanywhere.com";

// GET methods session

Future<Iterable> getTransfert(String date) async {
  var url = Uri.parse("$HOST/api/transferts?date=$date");
  http.Response response = await http.get(url);
  var decoded = [];
  if (response.statusCode == 200) {
    String data = response.body;
    decoded = jsonDecode(data);
  } else {
    decoded = [];
  }
  return decoded;
}

Future<Iterable> getLivraison(String date) async {
  var url = Uri.parse("$HOST/api/livraisons?date=$date");
  http.Response response = await http.get(url);
  var decoded = [];
  if (response.statusCode == 200) {
    String data = response.body;
    decoded = jsonDecode(data);
  } else {
    decoded = [];
  }
  return decoded;
}

Future<bool> isUser(String _n_9032, String _n_9064) async {
  var CODE = "JK9X80L4RT";
  var url = Uri.parse(
      "$HOST/api/list?code=$CODE&_n_9032=$_n_9032&_n_9064=$_n_9064");
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    print("Ok");
    return true;
  }
  return false;
}

// POST methods section
bool postTransfert(
    {required String date,
    required String plaque,
    required String logistic_official,
    required String numero_mouvement,
    required String district,
    required String stock_central_depart,
    required List<String> stock_central_suivants,
    required String stock_central_retour,
    required String photo_mvt,
    required String type_transport,
    String? motif}) {
  return true;
}
