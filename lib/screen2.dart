import 'package:soft/excel_fields.dart';
import 'package:flutter/material.dart';
import 'package:soft/custom_widgets.dart';
//import 'package:soft/rest.dart';


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
        appBar: AppBar(title: Text("Program", style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body:
            SingleChildScrollView(
              child:
                Column(
                    children: [
                      SizedBox(height: 20),
                      DatePicker(),
                      Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(20),
                          child:
                          Column(
                            children: [
                              TextField(
                                style: TextStyle(color: textColor, fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: "Nom du Logistic official...",
                                ),
                              ),
                              TextField(
                                style: TextStyle(color: textColor, fontSize: 15),
                                decoration: InputDecoration(

                                  hintText: "Plaque...",
                                ),
                              ),
                              TextField(
                                style: TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  hintText: "Numero du mouvement...",
                                ),
                              ),
                              Stock(hintText: "Stock Central Depart", column: STOCK_CENTRAL, background: background,),
                            ],
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(onPressed: (){
                          },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                            child: Text("Livraison", style: TextStyle(color: Colors.black)),
                          ),
                          ElevatedButton(onPressed: (){},
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
