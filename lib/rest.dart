import 'package:http/http.dart' as http;
import 'dart:convert';

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

Future<bool> isUser(String _n_9032, String _n_9064) async {
  var CODE = "JK9X80L4RT";
  var url =
      Uri.parse("http://192.168.43.43:5000/api/list?code=$CODE&_n_9032=$_n_9032&_n_9064=$_n_9064");
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}
