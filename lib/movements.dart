import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:soft/custom_widgets.dart';
import 'package:soft/excel_fields.dart';
import 'package:soft/rest.dart';
import 'dart:convert';

late Color? background;
late Color? fieldColor;
late bool changeTheme;
late Transfert? objTransfert;
late Livraison? objLivraison;

class ScreenTransition{
  late Color? backgroundColor;
  late Color? FieldColor;
  late bool changeThemes;
  late Transfert objtransfert;
  late Livraison objlivraison;
  ScreenTransition({required this.backgroundColor, required this.FieldColor,
    required this.changeThemes, required this.objtransfert,
    required this.objlivraison
  }){
    background = backgroundColor;
    fieldColor = FieldColor;
    changeTheme = changeThemes;
    objTransfert = objtransfert;
    objLivraison = objlivraison;
  }
}

class Movements extends StatefulWidget {
  const Movements({super.key});

  @override
  State<Movements> createState() => _MovementsState();
}

class _MovementsState extends State<Movements> {
  Set program = {"Transfert"};
  List content = [];
  String data="";
  bool isLoading = false;
  Map<String, dynamic> suivants = {};

  void populateContent({required String program, required String date, String? user}) async {
    setState(() {
      isLoading = true;
    });
    if (program == "Transfert"){
      var newContent = await getTransfert(date, user!);
      setState(() {
        isLoading = false;
        content = newContent;
      });
    }
    else{
      var newContent = await getLivraison(date, user!);
      setState(() {
        isLoading = false;
        content = newContent;
      });
    }
  }

  void updateSelected(Set newValue){
    setState(() {
      program = newValue;
    });
  }

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
      title: "Soft",
      home: Scaffold(
        backgroundColor: background,
        appBar: AppBar(title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context, '/second');
        }, icon: Icon(Icons.arrow_back, color: Colors.black,)),
            IconButton(onPressed: (){
              Navigator.popUntil(context, (route){
                return route.isFirst;
              });
            }, icon: Icon(Icons.logout, color: Colors.black)
            ),
          ],
        ),
            backgroundColor: Colors.lightGreen),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              DatePicker(),
              SizedBox(height: MediaQuery.of(context).size.height*0.02),
			  SegmentedButton(segments: [
				ButtonSegment(value: "Livraison",
				  label: Text("Livraison"),
				),
				ButtonSegment(value: "Transfert",
				  label: Text("Transfert")
				)
			  ],
				selected: program,
				onSelectionChanged: updateSelected,
				selectedIcon: Icon(Icons.fire_truck),
				style: SegmentedButton.styleFrom(selectedBackgroundColor: Colors.lightGreen
				),
			  ),
              SizedBox(height: 15),
			  IconButton(onPressed: (){
				setState(() {
				  String newDate = dateSelected == null ? "*" :
				  "${dateSelected?.day}/${dateSelected?.month}/${dateSelected?.year}";
				  populateContent(program: program.first, date: newDate, user: objTransfert == null ? objLivraison?.user : objTransfert?.user);
				});
			  },
				style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
				icon: Icon(Icons.list_alt, color: Colors.black)),
              SizedBox(height: MediaQuery.of(context).size.height*0.02),
              isLoading ? CircularProgressIndicator() : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: content.map((element) => Padding(
                padding: const EdgeInsets.all(12.0),
                    child: CardList(data: element, program: program.first),
    )).toList()
    )
    ]))
    ));
  }
}
