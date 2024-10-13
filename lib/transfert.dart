import 'package:flutter/material.dart';
import 'package:soft/rest.dart';
import 'package:soft/custom_widgets.dart';

late Color? Background;
late Transfert objTransfert;
class ScreenTransition{
  late Color? backgroundColor;
  late Transfert objtransf;
  ScreenTransition({required this.backgroundColor, required this.objtransf}){
    Background = backgroundColor;
    objTransfert = objtransf;
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
      title: "Transfert",
      home: Scaffold(
        backgroundColor: Background,
        appBar: AppBar(title: Text("Transfert", style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(child: Column(
          children: [
            stockCentralSuivant(),
            ElevatedButton(onPressed: (){},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                child: Text("Suivant", style: TextStyle(color: Colors.black))),
            Text(objTransfert.date),
            Text(objTransfert.plaque),
            Text(objTransfert.logistic_official),
            Text(objTransfert.stock_central_depart),
          ],
        )),
      ),
    );
  }
}
