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
  bool passwordVisible = true;
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Soft",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          primarySwatch: Colors.green
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[900],
          body: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            color: Colors.grey[900],
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    SizedBox(height: 70.0,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/drawer.png",
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200),
                      ),
                    SizedBox(height: 70.0,),
                    TextField(
                      style: TextStyle(
                        color: Colors.grey[300]
                      ),
                      decoration: InputDecoration(
                        hintText: "$username",
                        suffixIcon: Icon(Icons.person_2_rounded)
                      ),
                      cursorColor: Colors.amber,
                      cursorHeight: 15.0,
                      cursorWidth: 1.0,
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      obscureText: !passwordVisible,
                      style: TextStyle(
                        color: Colors.grey[300]
                      ),
                      decoration: InputDecoration(
                          hintText: "$pssw",
                        suffixIcon: IconButton(icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: (){
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                          },
                      )),
                      cursorColor: Colors.amber,
                      cursorHeight: 15.0,
                      cursorWidth: 1.0,
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isClicked = !isClicked;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isClicked? Colors.lightGreenAccent : Colors.lightGreen
                        ),
                        child: const Text(
                          "Se connecter",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ))
              ])))
            ),
          );
  }
}
