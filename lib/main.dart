import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Soft/excel_fields.dart';

void main() => runApp(const Home());

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? username = "Nom d'utilisateur...";
  String? pssw = "Mot de passe...";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Soft",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: Colors.grey[900],
          body: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            color: Colors.grey[900],
            child: Column(
              children: [
                Container(
                  child: Image.asset("assets/app-icon.png")
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    hintText: "$username",
                  ),
                  cursorColor: Colors.amber,
                  cursorHeight: 15.0,
                  cursorWidth: 1.0,
                ),
                const SizedBox(height: 30.0),
                TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      hintText: "$pssw"),
                  cursorColor: Colors.amber,
                  cursorHeight: 15.0,
                  cursorWidth: 1.0,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.lightGreen),
                        elevation: WidgetStatePropertyAll(50.0)),
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ))
              ],
            ),
          ),
        ));
  }
}
