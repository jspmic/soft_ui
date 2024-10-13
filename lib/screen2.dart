import 'dart:math';

import 'package:soft/excel_fields.dart';
import 'package:flutter/material.dart';
import 'package:soft/custom_widgets.dart';
import 'package:soft/transfert.dart' as transfert;
import 'package:soft/livraison.dart' as livraison;
import 'package:soft/rest.dart';


late Color? background;
class ScreenTransition{
  late Color? backgroundColor;
  ScreenTransition({required this.backgroundColor}){
    background = backgroundColor;
  }
}

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  Transfert objTransfert = Transfert();
  final logistic_official = TextEditingController();
  final plaque = TextEditingController();
  final numero_mvt = TextEditingController();
  //final _uname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color? textColor = (background == Colors.white ? Colors.black : Colors.white);
    return MaterialApp(
      theme: ThemeData(
        colorScheme: background == Colors.white ? const ColorScheme.light(primary: Colors.lightGreen)
            : const ColorScheme.dark(primary: Colors.lightGreen),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: background,
          dividerColor: Colors.lightGreen,
        )
      ),
      title: "Program",
      home: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: Align(
            alignment: Alignment.topRight,
              child: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.logout, color: Colors.black)
              )
          ),
          backgroundColor: Colors.lightGreen,
        ),
        body:
            SingleChildScrollView(
              child:
                Column(
                    children: [
                      SizedBox(height: 10),
                      DatePicker(),
                      Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(20),
                          child:
                          Column(
                            children: [
                              TextField(
                                style: TextStyle(color: textColor, fontSize: 15),
                                controller: logistic_official,
                                decoration: InputDecoration(
                                  hintText: "Nom du Logistic official...",
                                ),
                              ),
                              TextField(
                                style: TextStyle(color: textColor, fontSize: 15),
                                controller: plaque,
                                decoration: InputDecoration(

                                  hintText: "Plaque...",
                                ),
                              ),
                              TextField(
                                style: TextStyle(fontSize: 15),
                                controller: numero_mvt,
                                decoration: InputDecoration(
                                  hintText: "Numero du mouvement...",
                                ),
                              ),
                              Stock(hintText: "Stock Central Depart", column: STOCK_CENTRAL, background: background,
                              onSelect: (value){
                                objTransfert.stock_central_depart = value;
                              },
                              ),
                            ],
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(onPressed: (){
                            Navigator.pushNamed(context, "/livraison",
                                arguments: livraison.ScreenTransition(backgroundColor: background)
                            );
                          },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                            child: Text("Livraison", style: TextStyle(color: Colors.black)),
                          ),
                          ElevatedButton(onPressed: (){
                            objTransfert.plaque = plaque.text;
                            objTransfert.logistic_official = logistic_official.text;
                            objTransfert.date = "${dateSelected?.day}/${dateSelected?.month}/${dateSelected?.year}";
                            Navigator.pushNamed(context, "/transfert",
                              arguments: transfert.ScreenTransition(backgroundColor: background,
                                objtransf: objTransfert
                              )
                            );
                          },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                            child: Text("Transfert", style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
                    ]),
            )
      ),
    );
  }
}
