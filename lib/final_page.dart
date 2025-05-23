import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:soft/excel_fields.dart';
import 'package:soft/rest.dart';
import 'package:soft/custom_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

late Color? background;
late Color? fieldColor;
late Transfert? objtransf;
late Livraison? objLivraison;

class ScreenTransition{
  late Color? backgroundColor;
  late Color? fieldcolor;
  late Transfert? objectTransfert;
  late Livraison? objectLivraison;

  ScreenTransition({required this.backgroundColor, required this.fieldcolor,
    this.objectTransfert, this.objectLivraison}){
    background = backgroundColor;
    objtransf = objectTransfert;
    objLivraison = objectLivraison;
    fieldColor = fieldcolor;
  }
}

class Final extends StatefulWidget {
  const Final({super.key});

  @override
  State<Final> createState() => _FinalState();
}

class _FinalState extends State<Final> {
  Uint8List? _image;
  Color? mssgColor = background; // default status color is the background's color for stale
  Uint8List? _journal;
  int quality = 50;
  CompressFormat format=CompressFormat.jpeg;
  TextEditingController motif = TextEditingController();

  Future<XFile?> fromGallery(int src) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final String targetPath = p.join(
          Directory.systemTemp.path, 'temp.${format.name}');
      final XFile? compressedImage = await FlutterImageCompress
          .compressAndGetFile(
          pickedFile.path,
          targetPath,
          quality: quality,
          format: format
      );
      Uint8List selectedImage;
      if (compressedImage != null) {
        selectedImage = File(compressedImage.path).readAsBytesSync();
      }
      else {
        selectedImage = File(pickedFile.path).readAsBytesSync();
      }
      if (src == 0) {
        setState(() {
          _image = selectedImage;
        });
      }
      else{
        setState(() {
          _journal = selectedImage;
        });
      }
    }
    return pickedFile;
  }

  Future<XFile?> fromCamera(int src) async{
    final imagePicker = ImagePicker();
	XFile? compressedImage;
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final String targetPath = p.join(
          Directory.systemTemp.path, 'temp.${format.name}');
	  try{
		  compressedImage = await FlutterImageCompress
			  .compressAndGetFile(
			  pickedFile.path,
			  targetPath,
			  quality: quality,
			  format: format
		  );
		}
		on Exception{
			compressedImage = pickedFile;
		}
      Uint8List selectedImage;
      if (compressedImage != null) {
        selectedImage = File(compressedImage.path).readAsBytesSync();
      }
      else {
        selectedImage = File(pickedFile.path).readAsBytesSync();
      }
      if (src == 0) {
        setState(() {
          _image = selectedImage;
        });
      }
      else{
        setState(() {
          _journal = selectedImage;
        });
      }
    }
    return pickedFile;
  }

  void imagePicker(BuildContext context, int sourceCode){
    showModalBottomSheet(backgroundColor: background == Colors.white? Colors.black
        : Colors.white, context: context, builder: (builder){
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/6,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => fromGallery(sourceCode),
                  child: Column(
                    children: [
                      Icon(Icons.image_rounded, size: 40, color: background == Colors.white ? Colors.white :
                      Colors.black,),
                      Text("Gallery", style: TextStyle(color: background == Colors.white ? Colors.white :
                      Colors.black),)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => fromCamera(sourceCode),
                  child: Column(
                    children: [
                      Icon(Icons.camera_alt, size: 40, color: background == Colors.white ? Colors.white :
                      Colors.black,),
                      Text("Camera", style: TextStyle(color: background == Colors.white ? Colors.white :
                      Colors.black),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  bool isLoading = false;
  String mssg = "";

  void save({Transfert? objtransf, Livraison? objlivraison}) async{
    setState(() {
      isLoading = false;
      mssg = "";
    });
    isLoading = true;
    Response? isValidRequest = objtransf != null ? await objtransf.postMe() : await objlivraison?.postMe();
    setState(() {
      isLoading = false;
    });

    if (isValidRequest!.statusCode < 400) {
      setState(() {
		mssgColor = Colors.green;
        mssg = "Success!";
      });
    }
    else {
      setState(() {
		mssgColor = Colors.red;
        mssg = "Echec!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? textColor = (background == Colors.white ? Colors.black : Colors.white);
    return MaterialApp(
      theme: ThemeData(
          colorScheme: background == Colors.white ? const ColorScheme.light(primary: Colors.lightGreen)
              : const ColorScheme.dark(primary: Colors.lightGreen),
          datePickerTheme: DatePickerThemeData(
            backgroundColor: background,
            dividerColor: Colors.lightGreen,
          )
      ),
      title: "Soft",
      home: Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){
                  Navigator.popUntil(context, (route){
                    return route.settings.name == "/second";
                  });
                }, icon: Icon(Icons.redo_rounded, color: Colors.black)),
                IconButton(onPressed: (){
                  Navigator.popUntil(context, (route){
                    return route.isFirst;
                  });
                  }, icon: Icon(Icons.logout, color: Colors.black))
                  ],
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.lightGreen,
                  ),
                  body:
                  SingleChildScrollView(
                  child:
                  Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  SizedBox(height: 10),
                  Stock(hintText: "Stock Central Retour",
                  column: STOCK_CENTRAL,
                  background: background, onSelect: (value){
                      objLivraison != null ? objLivraison?.stock_central_retour = value
                          : objtransf?.stock_central_retour = value;
                        }),
                    SizedBox(height: 20),
                    Stock(hintText: "Type de Transport",
                        column: TYPE_TRANSPORT,
                        background: background, onSelect: (value){
                          objLivraison != null ? objLivraison?.type_transport = value
                              : objtransf?.type_transport = value;
                        }),
                    Padding(padding: EdgeInsets.all(30), child: TextField(
                      style: TextStyle(color: textColor, fontSize: 15),
                      controller: motif,
                      decoration: InputDecoration(
                        hintText: "Motif...",
                      ),
                    )),
                    //Divider(),
                    SizedBox(height: 10.0),
                    Text("Photo du mouvement"),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _image != null ?
                              CircleAvatar(
                                radius: 80, backgroundImage: MemoryImage(_image!),
                              )
                          : const CircleAvatar(radius: 80),
                          IconButton(onPressed: () => imagePicker(context, 0), icon: const Icon(Icons.add_photo_alternate)),
                        ],
                      )),
                    //Divider(height: 20.0),
                    SizedBox(height: 10.0),
                    Text("Photo du journal du camion"),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _journal != null ?
                              CircleAvatar(
                                radius: 80, backgroundImage: MemoryImage(_journal!),
                              )
                          : const CircleAvatar(radius: 80),
                          IconButton(onPressed: () => imagePicker(context, 1), icon: const Icon(Icons.add_photo_alternate)),
                        ],
                      ),
                    ),
                isLoading ? CircularProgressIndicator()
                    : ElevatedButton(onPressed: (){
                  objLivraison?.motif = motif.text;
                  objtransf?.motif = motif.text;
				  if (_image == null && _journal == null){
					  setState(() {
						mssgColor = Colors.red;
						mssg = "Ajouter au moins une photo";
					  });
					  return;
				  }
                  String imageB64 = _image != null ? base64Encode(_image!.toList()) : "";
                  String journalB64 = _journal != null ? base64Encode(_journal!.toList()) : "";
                  objtransf?.photo_mvt = imageB64;
                  objtransf?.photo_journal = journalB64;
                  objLivraison?.photo_mvt = imageB64;
                  objLivraison?.photo_journal = journalB64;
                  save(objtransf: objtransf, objlivraison: objLivraison);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen), child: Text("Enregistrer",
                        style: TextStyle(color: Colors.black))),
                    SizedBox(height: 10),
                    Text(mssg, style: TextStyle(color: mssgColor))
                  ]
    )
            ))
      ));
  }
}
