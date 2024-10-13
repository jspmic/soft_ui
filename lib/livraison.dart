import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:soft/rest.dart';
import 'package:soft/custom_widgets.dart';
import 'package:soft/excel_fields.dart';

late Color? background;
class ScreenTransition{
  late Color? backgroundColor;
  ScreenTransition({required this.backgroundColor}){
    background = backgroundColor;
  }
}

class LivraisonScreen extends StatefulWidget {
  const LivraisonScreen({super.key});

  @override
  State<LivraisonScreen> createState() => _TransfertScreenState();
}

class _TransfertScreenState extends State<LivraisonScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: background == Colors.white ? const ColorScheme.light(primary: Colors.lightGreen)
              : const ColorScheme.dark(primary: Colors.lightGreen)),
      title: "Livraison",
      home: Scaffold(
        backgroundColor: background,
        appBar: AppBar(title: const Text("Livraison", style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(child: Column(
          children: [
          Stock(hintText: "District", column: DISTRICT, background: background,
          onSelect: (value){}),
            Boucle(),
            ElevatedButton(onPressed: (){},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                child: Text("Suivant", style: TextStyle(color: Colors.black)))
          ],
        )),
      ),
    );
  }
}