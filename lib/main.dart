import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Soft",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: Colors.grey[900],
            appBar: AppBar(
              elevation: 0.0,
              title: const Text("", style: TextStyle(color: Colors.white),),
              centerTitle: true,
              backgroundColor: Colors.lightGreen[900],
            ),
          body: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                      "Bienvenue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30
                      ),
                    ),
                    SizedBox(height: 40,),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Nom d'utilisateur..."
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      decoration: InputDecoration(
                          hintText: "Mot de passe..."
                      ),
                    ),
                  ],
            ),
          ),
        ));
  }
}
