import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:Soft/rest.dart';

class Screen2 extends StatelessWidget {
  const Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Program",
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(title: Text("Program"),
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
        ),
        body:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 90,),
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
      ),
    );
  }
}
