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

// Constants section
Color? background = Colors.grey[900];

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
	// Remove initialize(to be replaced with cache population in rest.dart
    //initialize();
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
  bool changeTheme = false;

  bool isLoading = false;
  bool isaUser = false;
  Color state = Colors.white;
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
    //bool isValidUser = true;
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
      return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Scaffold(
              appBar: AppBar(title:  Align(
                alignment: Alignment.topRight,
                child: IconButton(onPressed: (){
                  setState(() {
                    background = changeTheme ? Colors.grey[900] : Colors.white;
                    fieldColor = changeTheme ? Colors.grey[300] : Colors.black;
                    state = background == Colors.white ? Colors.black : Colors.white;
                    changeTheme = !changeTheme;
                  });}, icon: Icon(background == Colors.white ? Icons.dark_mode_outlined
                    : Icons.light_mode,), style: IconButton.styleFrom(
                    backgroundColor: Colors.lightGreen)),),
                backgroundColor: background,
              ),
              resizeToAvoidBottomInset: true,
              backgroundColor: background,
              body: Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    SizedBox(
                      height: 20.0,
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
                        //Text(errormssg, style: TextStyle(color: Colors.red)),
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
