import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:soft/custom_widgets.dart';
import 'package:soft/rest.dart';
import 'package:crypto/crypto.dart';
import 'package:soft/screen2.dart' as screen2;
import 'package:soft/movements.dart' as movements;
import 'package:soft/transfert.dart' as transfert;
import 'package:soft/livraison.dart' as livraison;
import 'package:soft/final_page.dart' as final_page;

// These will be defined later depending on the context we're in
// background: will contain the startup background depending on the device's theme
// changeTheme: will determine the boolean value,
// that represents whether to change the theme to dark or light
late Color? background;
late bool changeTheme;

// Function that returns the Color depending on the device's theme
Color? getDeviceTheme(BuildContext context){
  // Determines automatically the mode of the device(light or dark)
  // This is used to determine the starting theme of the app
  Brightness brightness = MediaQuery.of(context).platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;
  // This boolean variable will be used to change theme inside the app temporarily
  // It is needed when the startup theme is not appropriate in given conditions(sun, ...)
  changeTheme = isDarkMode ? false : true;

  // Determines the background color depending on the device mode
  // This background will be used to determine the theme of the app automatically
  return isDarkMode ? Colors.grey[900] : Colors.white;
}

void main() => runApp(const Login());

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/second': (context) => const screen2.Screen2(),
          '/movements': (context) => const movements.Movements(),
          '/transfert': (context) => const transfert.TransfertScreen(),
          '/livraison': (context) => const livraison.LivraisonScreen(),
          '/final': (context) => const final_page.Final(),
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
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _validateField(String? value){
    setState(() {
      state = Colors.red;
    });
    return value == null || value.isEmpty ? "Champ obligatoire" : null;
  }

  bool passwordVisible = false;

  Color? fieldColor = Colors.grey[300];

  bool isLoading = false;
  Color state = background == Colors.white ? Colors.black : Colors.white;
  String _uname = "";
  String _pssw = "";

  var username = TextEditingController();
  var pssw = TextEditingController();

  Transfert objTransfert = Transfert();
  Livraison objLivraison = Livraison();

  void authenticate() async{
    if (_formKey.currentState!.validate()){
      _formKey.currentState?.save();
    }
    else{
      return;
    }
    setState(() {
      isLoading = false;
      state = Colors.blue;
    });
    isLoading = true;
    String _hashed = sha256.convert(utf8.encode(_pssw)).toString();
    bool isValidUser = await isUser(_uname, _hashed);
    setState(() {
      isLoading = false;
    });

    if (mounted && isValidUser) {
      state = Colors.green;
      objTransfert.user = _uname;
      objLivraison.user = _uname;
      username.text = "";
      pssw.text = "";
      Navigator.pushNamed(context, '/second',
          arguments: screen2.ScreenTransition(backgroundColor: background, FieldColor: fieldColor,
              changeThemes: changeTheme, objtransfert: objTransfert, objlivraison: objLivraison
          )
      );
    }
    else {
      setState(() {
        state = Colors.red;
      });
    }
    }

  @override
  Widget build(BuildContext context){
      background = getDeviceTheme(context);
      state = background == Colors.white ? Colors.black : Colors.white;
      return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: background,
              body: Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height/7,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/icon/drawer2.png",
                          fit: BoxFit.cover, width: 200, height: 200),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                        Icon(Icons.circle_outlined, color: state),
                        SizedBox(height: 8),
                    Form(key: _formKey, child: Padding(padding: EdgeInsets.all(16.0), child:
                      Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Nom d'utilisateur",
                                labelStyle: TextStyle(color: background == Colors.white ? Colors.black : Colors.white, fontSize: 12),
                            ),
                            controller: username,
                            style: TextStyle(color: background == Colors.white ? Colors.black : Colors.white),
                            validator: (value) => _validateField(value),
                            onSaved: (value) => _uname = value!,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Mot de passe",
                              labelStyle: TextStyle(color: background == Colors.white ? Colors.black : Colors.white, fontSize: 12)
                            ),
                            obscureText: !passwordVisible,
                            controller: pssw,
                            style: TextStyle(color: background == Colors.white ? Colors.black : Colors.white),
                            validator: (value) => _validateField(value),
                            onSaved: (value) => _pssw = value!,
                          )
                        ],
                      ))),
                        SizedBox(height: 12.0),
                        isLoading ? CircularProgressIndicator()
                            : ElevatedButton(onPressed: authenticate,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                          child: Text("Se connecter", style: TextStyle(color: Colors.black),),),
                  ]))),
          ),
        );
  }
}
