import 'package:flutter/material.dart';
import 'package:soft/models/superviseur.dart';
import 'package:soft/rest.dart';
import 'package:soft/custom_widgets.dart';
import 'package:soft/final_page.dart' as final_page;

late Color? Background;
late Color? fieldColor;
late Superviseur superviseur;
late Transfert objTransfert;

class ScreenTransition{
  late Color? backgroundColor;
  late Color? fieldcolor;
  late Transfert objtransf;
  late Superviseur s;

  ScreenTransition({required this.backgroundColor,
    required this.fieldcolor, required this.objtransf, required this.s}){
    Background = backgroundColor;
    fieldColor = fieldcolor;
    objTransfert = objtransf;
	superviseur = s;
  }
}

class TransfertScreen extends StatefulWidget {
  const TransfertScreen({super.key});
  @override
  State<TransfertScreen> createState() => _TransfertScreenState();
}

class _TransfertScreenState extends State<TransfertScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
        colorScheme: Background == Colors.white ? const ColorScheme.light(primary: Colors.lightGreen)
        : const ColorScheme.dark(primary: Colors.lightGreen)),
      title: "Soft",
      home: Scaffold(
        backgroundColor: Background,
        appBar: AppBar(title: Text("Transfert", style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(child: Center(
          child: Column(
            children: [
              stockCentralSuivant(),
              ElevatedButton(onPressed: (){
                Navigator.pushNamed(context, '/final',
                  arguments: final_page.ScreenTransition(backgroundColor: Background,
					  s: superviseur,
                      fieldcolor: fieldColor, objectTransfert: objTransfert)
                );
              },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                  child: Text("Suivant", style: TextStyle(color: Colors.black))),
              Text("Date: ${objTransfert.date}"),
              Text("Plaque: ${objTransfert.plaque}"),
              Text("Logistic Official: ${objTransfert.logistic_official}"),
              Text("Numero du mouvement: ${objTransfert.numero_mouvement}"),
              Text("Stock Central Depart: ${objTransfert.stock_central_depart}"),
            ],
          ),
        )),
      ),
    );
  }
}
