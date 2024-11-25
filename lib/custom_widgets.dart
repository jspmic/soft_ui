import 'dart:io';
import 'package:soft/excel_fields.dart';
import 'package:flutter/material.dart';
import 'package:soft/screen2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soft/transfert.dart' as transfert;
import 'package:soft/livraison.dart' as livraison;

Map<int, Iterable<String?>> cache = {};
Map<String?, Iterable<String?>> cache2 = {};

DateTime? dateSelected;
bool collineDisponible = false;

Future<String> _getDst() async {
  final directory = await getApplicationDocumentsDirectory();

  // Create the parent directory if it doesn't exist
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  return directory.path;
}

Future<File> _localFile(String fileName) async {
  final path = await _getDst();
  return File('$path/$fileName');
}

Future<String> readCounter(String fileName) async {
  final file = await _localFile(fileName);

  // Read the file
  return file.readAsString();
}

Future<File> writeCounter(String fileName, String content) async {
  final file = await _localFile(fileName);

  // Write the file
  return file.writeAsString(content, mode: FileMode.append);
}


// Function to capitalize a string
String capitalize(String string){
  return string[0].toUpperCase() + string.substring(1, string.length);
}

// Function to list all the contents of the specified column in the sheet
void list(int column, {String? district}) async{
  Worksheet workSheet = await Worksheet.fromAsset("assets/worksheet.xlsx");
  if (district == null) {
    cache[column] = workSheet.readColumn("Feuille 1", column);
  }
  else{
    if (cache2.containsKey(district) == true){
      return;
    }
    cache2[district] = workSheet.readColline("Feuille 1", district);
  }
}

void initialize({String? district}){
  if (district != null && !(cache2.containsKey(district))){
    list(DISTRICT+5, district: district);
    return;
  }
  list(STOCK_CENTRAL);
  list(TYPE_TRANSPORT);
  list(INPUT);
  list(DISTRICT);
  list(LIVRAISON_RETOUR);
}

// Custom DatePicker widget
class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _date;
  Future _selectDate(BuildContext context) async => showDatePicker(context: context,
      firstDate: DateTime(2005), lastDate: DateTime(2090), initialDate: DateTime.now()
  ).then((DateTime? selected) {
    if (selected != null && selected != _date) {
      setState(() {
        _date = selected;
        dateSelected = _date;
      });
    }
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(onPressed: () => _selectDate(context),
            style: ElevatedButton.styleFrom(backgroundColor: background),
            child: Text(_date == null ? "Date" : "${_date?.day}/${_date?.month}/${_date?.year}",
                style: TextStyle(color: background == Colors.white ? Colors.black : Colors.white),
              )),
        ],
      ),
    );
  }
}

// Function to return a drop-down of all the cell values in a column in the sheet
class Stock extends StatefulWidget {
  final String hintText;
  final int column;
  final String? district;
  final Color? background;
  final Function(String) onSelect;
  const Stock({super.key, required this.hintText, required this.column,
    required this.background, this.district, required this.onSelect});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  String _hintCopy = "Default";

  @override
  void initState(){
    _hintCopy = widget.hintText;
    /*if (widget.district != null){
      list(DISTRICT+5, district: widget.district);
	  }*/
    super.initState();
	}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal,
      child: DropdownButton<String?>(items: (widget.district != null ? cache2[widget.district] : cache[widget.column])
          ?.map((choice){
        return DropdownMenuItem(value: choice, child: Text(choice.toString()));
      }).toList(), onChanged: (value){
        setState(() {
          _hintCopy = value!;
          widget.onSelect(value);
        });
      }, hint: Text(_hintCopy, style: TextStyle(color: widget.background == Colors.white ? Colors.black
          : Colors.white)),
    style: TextStyle(color: widget.background == Colors.white ?  Colors.black
        : Colors.white)
    ));
  }
}

class stockCentralSuivant extends StatefulWidget {
  const stockCentralSuivant({super.key});

  @override
  State<stockCentralSuivant> createState() => _stockCentralSuivantState();
}

class _stockCentralSuivantState extends State<stockCentralSuivant> {
  List<Widget> _stockWidgets = [];
  int index = 0;

  void newStock(int counter){
    _stockWidgets.add(Stock(hintText: "Stock Central Suivant",
      column: STOCK_CENTRAL,
      background: transfert.Background,
      onSelect: (value){
      transfert.objTransfert.stock_central_suivants[counter.toString()] = value;
      },
    ));
  }
  @override
  void initState(){
    newStock(index);
    index += 1;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ..._stockWidgets,
          ElevatedButton(onPressed: (){
            setState(() {
              newStock(index);
              index += 1;
            });
          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              child: Icon(Icons.add, color: Colors.black)),
        ]),
      );
  }
}

List<Map<String, String>> oneBoucle = [];
int count=0;

class Boucle extends StatefulWidget {
  final String district;
  final List<Widget> boucle;
  const Boucle({super.key, required this.boucle, required this.district});

  @override
  State<Boucle> createState() => _BoucleState();
}

class _BoucleState extends State<Boucle> {

  List<Widget> initBoucle = [];
  List<Widget> create_boucle(List<Widget> _boucle, int count){
    oneBoucle.add({});
    _boucle.add(Stock(hintText: "Livraison Retour",
        column: LIVRAISON_RETOUR,
        background: background,
        onSelect: (value) {
      setState(() {
        oneBoucle[count]["livraison_retour"] = value;
      });
        }
    )
    );
      _boucle.add(Stock(hintText: "Colline",
          column: DISTRICT+5,
          district: widget.district,
          background: background,
          onSelect: (value) {
            setState(() {
              oneBoucle[count]["colline"] = value;
            });
          }
      )
      );
      _boucle.add(Stock(hintText: "Produit",
          column: INPUT,
          background: background,
          onSelect: (value) {
            setState(() {
              oneBoucle[count]["input"] = value;
            });
          }
      )
      );
      _boucle.add(TextField(
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: "Quantité...",
        ),
        onChanged: (value){
          oneBoucle[count]["quantite"] = value;
        },

      ));
	  return _boucle;
  }
  @override
  void initState(){
	count = 0;
	oneBoucle = [];
	objLivraison.boucle = {};
    initBoucle = create_boucle(initBoucle, count);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...initBoucle,
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              setState(() {
                livraison.objLivraison.boucle[count.toString()] = oneBoucle[count];
                count +=1;
                create_boucle(initBoucle, count);
              });
            },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                child: Icon(Icons.add, color: Colors.black)),
          ]),
    );
  }
}

class CardList extends StatelessWidget {
  final Map data;
  final String program;
  const CardList({super.key, required this.data, required this.program});

  void movementViewer(BuildContext context){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(data["date"].toString()),
        content: program == "Transfert" ?
        Text("Logistic Official: ${data["logistic_official"]}\n\n${data["stock_central_suivants"].values}\n\nRetour: ${data["stock_central_retour"]}\n\nMotif: ${data["motif"]}"):
        Text("Logistic Official: ${data["logistic_official"]}\n\nDistrict: ${data["district"]}\n\nRetour: ${data["stock_central_retour"]}\n\nMotif: ${data["motif"]}"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Fermer"))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
        elevation: 10.0,
        child: ListTile(
          trailing: Icon(Icons.navigate_next),
          title: Text(data["stock_central_depart"].toString()),
          subtitle: Text("Mouvement: ${data["numero_mouvement"].toString()}"),
          onTap: () => movementViewer(context),
        )
    );
  }
}
