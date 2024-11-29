import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:soft/custom_widgets.dart';
import 'package:soft/excel_fields.dart';

// Address definition
String? HOST;

init() async{
	cache[LIVRAISON_RETOUR] = ["Livraison", "Retour"];
	await dotenv.load(fileName: ".env");
	HOST = dotenv.env["HOST"].toString();
}
// const String HOST = "http://192.168.43.81:5000";


class Transfert{
  late String date;
  late String plaque;
  late String logistic_official;
  late String numero_mouvement;
  late String stock_central_depart;
  Map<String, String?> stock_central_suivants = {};
  late String stock_central_retour;
  String photo_mvt = "";
  String photo_journal = "";
  late String type_transport;
  late String user;
  late String? motif;
  Transfert();

  Future<http.Response> postMe() async{
    Uri url = Uri.parse("$HOST/api/transferts");
    Map images = await getUrl(photo_mvt, photo_journal);
	if (!images.containsKey("message")){
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
			'photo_mvt': images["image1"],
			'photo_journal': images["image2"],
			'type_transport': type_transport,
			'user': user,
			'motif': motif
		  })
		);
		return response;
	  }
	else{
		return http.Response("{\"message\": \"Pas de connexion\"}", 404);
		}
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
  String photo_journal = "";
  late String type_transport;
  late String user;
  late String? motif;
  Livraison();

  Future<http.Response> postMe() async{
    Map images = await getUrl(photo_mvt, photo_journal);
    Uri url = Uri.parse("$HOST/api/livraisons");
	if (!images.containsKey("message")){
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
			  'photo_mvt': images["image1"],
			  'photo_journal': images["image2"],
			  'type_transport': type_transport,
			  'user': user,
			  'motif': motif
			})
		).timeout(Duration(minutes: 1, seconds: 20));
		return response;
	}
	else{
		return http.Response("{\"message\": \"Pas de connexion\"}", 404);
	}
  }

}

// GET methods session

Future<List> getTransfert(String date, String user) async {
	var url = Uri.parse("$HOST/api/transferts?date=$date&user=$user");
	try {
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
	on Exception{
		return [];
	}
}

Future<List> getLivraison(String date, String user) async {
	var url = Uri.parse("$HOST/api/livraisons?date=$date&user=$user");
	try {
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
	on Exception{
		return [];
	}
}

Future<dynamic> getUrl(String image1, String image2) async {
Uri url = Uri.parse("$HOST/api/image");
	try{
		http.Response response = await http.post(
			url,
			headers: <String, String>{
			  'Content-Type': 'application/json; charset=UTF-8'
			},
			body: jsonEncode(<String, dynamic>{
				'image1': image1,
				'filename1': 'mouvement1.jpeg',
				'image2': image2,
				'filename2': 'mouvement2.jpeg'
			})
		);
		return jsonDecode(response.body);
	}
	on Exception{
		return jsonDecode(http.Response("{\"message\": \"Erreur du client\"}", 404).body);
	}
}

Future<bool> isUser(String _n_9032, String _n_9064) async {
	await dotenv.load(fileName: ".env");
  String code = dotenv.env["CODE"].toString();
  var url = Uri.parse("$HOST/api/list");
  try{
	  http.Response response = await http.get(url,
			headers: {"x-api-key": code,
				"Authorization": "$_n_9032:$_n_9064"}
		).timeout(Duration(seconds: 30), onTimeout: (){
		  return http.Response("No connection", 404);
	  });
	  if (response.statusCode == 200) {
			// Add column retrieval code here
			// The replacement for the initialize method lies here
			Map<String, dynamic> fields = jsonDecode(response.body);
			cache[DISTRICT] = fields["districts"]!;
			cache[TYPE_TRANSPORT] = fields["type_transports"]!;
			cache[STOCK_CENTRAL] = fields["stocks"]!;
			cache[INPUT] = fields["inputs"]!;
			return true;
	  }
	  return false;
  }
  on Exception{
  	return false;
  }
}
