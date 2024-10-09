import 'package:soft/excel_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  @override
  Widget build(BuildContext context) {
    Color? textColor = (background == Colors.white ? Colors.black : Colors.white);
    print(textColor==Colors.black);
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
                            ],
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(onPressed: (){},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                            child: Text("Livraison", style: TextStyle(color: Colors.black)),
                          ),
                          ElevatedButton(onPressed: (){},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                            child: Text("Transfert", style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      )
                    ]),
            )
      ),
    );
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _date;
  Future _selectDate(BuildContext context) async => showDatePicker(context: context,
      firstDate: DateTime(1920), lastDate: DateTime(3050), initialDate: DateTime.now()
  ).then((DateTime? selected) {
    if (selected != null && selected != _date) {
      setState(() => _date = selected);
    }
    });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () => _selectDate(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
            child: const Text("Selectionnez une date",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 20,),
          Text("Date: ${_date ?? "Aucune date"}",
          style: TextStyle(fontSize: 18, color: Colors.white))
        ],
      ),
    );
  }
}
