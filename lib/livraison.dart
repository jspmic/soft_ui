import 'package:flutter/material.dart';
import 'package:soft/rest.dart';
import 'package:soft/custom_widgets.dart';
import 'package:soft/final_page.dart' as final_page;

late Color? background;
late Color? fieldcolor;
late Livraison objLivraison;

class ScreenTransition{
  late Color? backgroundColor;
  late Color? fieldColor;
  late Livraison objlivraison;
  ScreenTransition({required this.backgroundColor, required this.fieldColor,
  required this.objlivraison}){
    background = backgroundColor;
    fieldcolor = fieldColor;
    objLivraison = objlivraison;
  }
}

class LivraisonScreen extends StatefulWidget {
  const LivraisonScreen({super.key});

  @override
  State<LivraisonScreen> createState() => _LivraisonScreenState();
}

class _LivraisonScreenState extends State<LivraisonScreen> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
          colorScheme: background == Colors.white ? const ColorScheme.light(primary: Colors.lightGreen)
              : const ColorScheme.dark(primary: Colors.lightGreen)),
      title: "Soft",
      home: Scaffold(
        backgroundColor: background,
        appBar: AppBar(title: const Text("Livraison", style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body: SingleChildScrollView(child: Column(
          children: [
            Boucle(district: objLivraison.district),
              ElevatedButton(onPressed: (){},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              child: IconButton(onPressed: (){
                objLivraison.boucle[count.toString()] = oneBoucle[count];
                Navigator.pushNamed(context, "/final",
                  arguments: final_page.ScreenTransition(backgroundColor: background, fieldcolor: fieldcolor,
                    objectLivraison: objLivraison
                  )
                );
              }, icon: Icon(Icons.navigate_next_sharp, color
            : Colors.black,))),
            SizedBox(height: 20,),
            Text("Date: ${objLivraison.date}"),
            Text("Plaque: ${objLivraison.plaque}"),
            Text("Logistic Official: ${objLivraison.logistic_official}"),
            Text("District: ${objLivraison.district}"),
            Text("Stock Central Depart: ${objLivraison.stock_central_depart}"),
            Text("Utilisateur: ${objLivraison.user}"),
          ],
        )),
      ),
    );
  }
}
