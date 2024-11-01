import 'package:flutter/material.dart';
import 'package:soft/custom_widgets.dart';
import 'package:soft/rest.dart';
import 'package:soft/screen2.dart' as screen2;
import 'package:soft/movements.dart' as movements;
import 'package:soft/transfert.dart' as transfert;
import 'package:soft/livraison.dart' as livraison;
import 'package:soft/final_page.dart' as final_page;

void main() => runApp(const Login());

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    initialize();
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
  Color? background = Colors.grey[900];
  String username = "";

  String pssw = "";

  bool passwordVisible = false;

  Color? fieldColor = Colors.grey[300];
  bool changeTheme = false;

  bool isLoading = false;
  bool isaUser = false;
  String errormssg = "";

  final _uname = TextEditingController();

  final _pssw = TextEditingController();

  Transfert objTransfert = Transfert();
  Livraison objLivraison = Livraison();

  void authenticate() async{
    setState(() {
      isLoading = false;
      errormssg = "";
    });
    isLoading = true;
    bool isValidUser = await isUser(_uname.text, _pssw.text);
    //bool isValidUser = true;
    setState(() {
      isLoading = false;
    });

    if (mounted && isValidUser) {
      objTransfert.user = _uname.text;
      objLivraison.user = _uname.text;
      _uname.text = "";
      _pssw.text = "";
      Navigator.pushNamed(context, '/second',
          arguments: screen2.ScreenTransition(backgroundColor: background, FieldColor: fieldColor,
              changeThemes: changeTheme, objtransfert: objTransfert, objlivraison: objLivraison
          )
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
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Scaffold(
            appBar: AppBar(title:  Align(
              alignment: Alignment.topRight,
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
            resizeToAvoidBottomInset: true,
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
                      Text(errormssg, style: TextStyle(color: Colors.red),),
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
