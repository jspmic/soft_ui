import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:soft/rest.dart';
import 'package:soft/screen2.dart';

void main() => runApp(const Login());

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/second': (context) => const Screen2(),
        },
        title: "Soft",
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
            useMaterial3: true,
            primarySwatch: Colors.lightGreen),
        home: LoginPage()
    );
  }
}
class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "";

  String pssw = "";

  bool passwordVisible = false;

  Color? background = Colors.grey[900];
  Color? fieldColor = Colors.grey[300];
  bool changeTheme = false;

  bool isLoading = false;
  String errormssg = "";

  final _uname = TextEditingController();

  final _pssw = TextEditingController();

  void authenticate(){ //async
    setState(() {
      isLoading = true;
      errormssg = "";
    });
    //bool isValidUser = await isUser(_uname.text, _pssw.text);
    bool isValidUser = true;
    setState(() {
      isLoading = false;
    });

    if (isValidUser) {
      Navigator.pushNamed(context, '/second',
        arguments: ScreenTransition(backgroundColor: background)
      );
    }
    else {
      setState(() {
        errormssg = "Utilisateur non existant !";
      });
    }
    }

  @override
  Widget build(BuildContext context){
      return
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Scaffold(
            appBar: AppBar(title:  Align(
              alignment: Alignment.bottomRight,
              child: IconButton(onPressed: (){
                setState(() {
                  background = changeTheme ? Colors.grey[900] : Colors.white;
                  fieldColor = changeTheme ? Colors.grey[300] : Colors.black;
                  changeTheme = !changeTheme;
                });}, icon: Icon(background == Colors.white ? Icons.dark_mode_outlined
                  : Icons.light_mode,), style: IconButton.styleFrom(
                  backgroundColor: Colors.lightGreen)),),
              backgroundColor: background,
            ),
            resizeToAvoidBottomInset: false,
            backgroundColor: background,
            body: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    child: Column(children: [
                  SizedBox(
                    height: 40.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset("assets/icon/drawer2.png",
                        fit: BoxFit.cover, width: 200, height: 200),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                      Text("$errormssg", style: TextStyle(color: Colors.red),),
                  SizedBox(height: 25,),
                  TextField(
                    style: TextStyle(color: fieldColor),
                    controller: _uname,
                    decoration: InputDecoration(
                        hintText: "Nom d'utilisateur...",
                        suffixIcon: Icon(Icons.person_2_rounded)),
                    cursorColor: Colors.amber,
                    cursorHeight: 15.0,
                    cursorWidth: 1.0,
                  ),
                  const SizedBox(height: 30.0),
                  TextField(
                    obscureText: !passwordVisible,
                    style: TextStyle(color: fieldColor),
                    controller: _pssw,
                    decoration: InputDecoration(
                        hintText: "Mot de passe...",
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
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
                      isLoading ? CircularProgressIndicator()
                          : ElevatedButton(onPressed: authenticate,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                        child: Text("Se connecter", style: TextStyle(color: Colors.black),),),

                ])))),
        );
  }
}
