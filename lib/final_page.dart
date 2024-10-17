import 'package:flutter/material.dart';
import 'package:soft/excel_fields.dart';
import 'package:soft/rest.dart';
import 'package:soft/custom_widgets.dart';

late Color? background;
late Color? fieldColor;
late Transfert? objtransf;
late Livraison? objLivraison;

class ScreenTransition{
  late Color? backgroundColor;
  late Color? fieldcolor;
  late Transfert? objectTransfert;
  late Livraison? objectLivraison;

  ScreenTransition({required this.backgroundColor, required this.fieldcolor,
    this.objectTransfert, this.objectLivraison}){
    background = backgroundColor;
    objtransf = objectTransfert;
    objLivraison = objectLivraison;
    fieldColor = fieldcolor;
  }
}

class Final extends StatefulWidget {
  const Final({super.key});

  @override
  State<Final> createState() => _FinalState();
}

class _FinalState extends State<Final> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: background == Colors.white ? const ColorScheme.light(primary: Colors.lightGreen)
              : const ColorScheme.dark(primary: Colors.lightGreen),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: background,
            dividerColor: Colors.lightGreen,
          )
      ),
      title: "Finalisation",
      home: Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            title: Text("Finalisation", style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.lightGreen,
          ),
          body:
          SingleChildScrollView(
            child:
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Stock(hintText: "Stock Central Retour",
                        column: STOCK_CENTRAL,
                        background: background, onSelect: (value){
                      objLivraison != null ? objLivraison?.stock_central_retour = value
                          : objtransf?.stock_central_retour = value;
                        }),
                    Stock(hintText: "Type de Transport",
                        column: TYPE_TRANSPORT,
                        background: background, onSelect: (value){
                          objLivraison != null ? objLivraison?.type_transport = value
                              : objtransf?.type_transport = value;
                        })
                  ],
                  ),
            )
      )));
  }
}
