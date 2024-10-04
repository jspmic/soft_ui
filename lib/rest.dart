import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  var transf = getLivraison("30/09/2014");
  transf.then((livraison) {
    for (var livr in livraison) {
      print(livr["boucle"]["1"]);
    }
  });
}

// GET methods session

Future<Iterable> getTransfert(String date) async {
  var url = Uri.parse("http://localhost:5000/api/transferts?date=$date");
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
  var url = Uri.parse("http://localhost:5000/api/livraisons?date=$date");
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
      "http://localhost:5000/api/list?code=$CODE&_n_9032=$_n_9032&_n_9064=$_n_9064");
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
