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
			'photo_journal': photo_journal,
			'type_transport': type_transport,
			'user': user,
			'motif': motif
		  })
		);
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
  String photo_journal = "";
  late String type_transport;
  late String user;
  late String? motif;
  Livraison();

  Future<http.Response> postMe() async{
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
			  'photo_journal': photo_journal,
			  'type_transport': type_transport,
			  'user': user,
			  'motif': motif
			})
		).timeout(Duration(minutes: 1, seconds: 20));
		return response;
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
			Map<String, dynamic> fields = jsonDecode(response.body);
			cache[DISTRICT] = fields["districts"]!;
			cache[TYPE_TRANSPORT] = fields["type_transports"]!;
			cache[STOCK_CENTRAL] = fields["stocks"]!;
			cache[INPUT] = fields["inputs"]!;
			for (String collineDistrict in fields["collines"]){
				List decodeOutput = jsonDecode(collineDistrict);
				// If cache contains district, add to the collines in district
				// If not, add the first colline as a list with one element, the colline itself
				cache2.containsKey(decodeOutput[1]) ? cache2[decodeOutput[1]]!.add(decodeOutput[0])
					: cache2[decodeOutput[1]] = [decodeOutput[0]];
				cache2[decodeOutput[1]]!.sort(); // sort the collines already in the district
			}
			cache[INPUT]?.sort();
			cache[DISTRICT]?.sort();
			return true;
	  }
	  return false;
  }
  on Exception{
  	return false;
  }
}
