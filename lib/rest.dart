import 'package:http/http.dart' as http;
import 'dart:convert';

// Address definition
const String HOST = "https://jspemic.pythonanywhere.com";
//const String HOST = "http://192.168.43.43:5000";


class Transfert{
  late String date;
  late String plaque;
  late String logistic_official;
  late String numero_mouvement;
  late String stock_central_depart;
  Map<String, String?> stock_central_suivants = {};
  late String stock_central_retour;
  String photo_mvt = "";
  late String type_transport;
  late String user;
  late String? motif;
  Transfert();

  Future<http.Response> postMe() async{
    Uri url = Uri.parse("$HOST/api/transferts");
    http.Response response = await http.post(
        url,
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'date': date,
        'plaque': plaque,
        'logistic_official': logistic_official,
        'numero_mouvement': numero_mouvement,
        'stock_central_depart': stock_central_depart,
        'stock_central_suivants': jsonEncode(stock_central_suivants),
        'stock_central_retour': stock_central_retour,
        'photo_mvt': photo_mvt,
        'type_transport': type_transport,
        'user': user,
        'motif': motif
      })
    );
    print(response.statusCode);
    print(response.body);
    return response;
  }
}

class Livraison{
  late String date;
  late String plaque;
  late String logistic_official;
  late String numero_mouvement;
  late String district;
  late String stock_central_depart;
  late Map<String, Map<String, String>> boucle = {};
  late String stock_central_retour;
  String photo_mvt = "";
  late String type_transport;
  late String user;
  late String? motif;
  Livraison();

  Future<http.Response> postMe() async{
    print(jsonEncode(jsonEncode(boucle)));
    Uri url = Uri.parse("$HOST/api/livraisons");
    http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'date': date,
          'plaque': plaque,
          'district': district,
          'logistic_official': logistic_official,
          'numero_mouvement': numero_mouvement,
          'stock_central_depart': stock_central_depart,
          'boucle': jsonEncode(boucle),
          'stock_central_retour': stock_central_retour,
          'photo_mvt': photo_mvt,
          'type_transport': type_transport,
          'user': user,
          'motif': motif
        })
    );
    print(response.statusCode);
    print(response.body);
    return response;
  }

}

// GET methods session

Future<List> getTransfert(String date, String user) async {
  var url = Uri.parse("$HOST/api/transferts?date=$date&user=$user");
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

Future<List> getLivraison(String date, String user) async {
  var url = Uri.parse("$HOST/api/livraisons?date=$date&user=$user");
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

Future<List> getUrl(String image) async {
  var url = Uri.parse("$HOST/api/image?image=$image&filename=mouvement.jpg");
  http.Response response = await http.get(url);
  var decoded = [];
  if (response.statusCode == 200) {
    String data = response.body;
    decoded = jsonDecode(data);
  } else {
    decoded = [];
  }
  print("$decoded -- url");
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