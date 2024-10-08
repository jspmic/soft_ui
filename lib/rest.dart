import 'package:http/http.dart' as http;
import 'dart:convert';

// GET methods session

Future<Iterable> getTransfert(String date) async {
  var url = Uri.parse("https://jspemic.pythonanywhere.com/api/transferts?date=$date");
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
  var url = Uri.parse("https://jspemic.pythonanywhere.com/api/livraisons?date=$date");
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
      "https://jspemic.pythonanywhere.com/api/list?code=$CODE&_n_9032=$_n_9032&_n_9064=$_n_9064");
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
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
    required String stock_central_suivants,
    required String stock_central_retour,
    required String photo_mvt,
    required String type_transport,
    String? motif}) {
  return true;
}
