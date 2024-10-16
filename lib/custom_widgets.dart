import 'package:soft/excel_fields.dart';
import 'package:flutter/material.dart';
import 'package:soft/screen2.dart';
import 'package:soft/rest.dart';
import 'package:soft/transfert.dart';

Map<int, Iterable<String?>> cache = {};
Map<String?, Iterable<String?>> cache2 = {};

DateTime? dateSelected;
bool collineDisponible = false;

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
  if (district != null){
    list(DISTRICT+5, district: district);
    return;
  }
  list(STOCK_CENTRAL);
  list(TYPE_TRANSPORT);
  list(INPUT);
  list(DISTRICT);
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () => _selectDate(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
            child: const Text("Selectionnez une date",
              style: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 10,),
          Text("Date: ${_date == null ? "Aucune date" : "${_date?.day}/${_date?.month}/${_date?.year}"}",
              style: TextStyle(fontSize: 18, color: background == Colors.white ? Colors.black
              : Colors.white))
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
    super.initState();
    if (widget.district != null){
      list(DISTRICT+5, district: widget.district);
    }
    else {
      list(widget.column);
    }
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
    /*return FutureBuilder<Iterable<String?>>(future: list(widget.column), builder: (context, snapshot){
      if (snapshot.connectionState == ConnectionState.waiting){
        return CircularProgressIndicator();
      }
      else if (snapshot.hasError){
        return Text("Error: ${snapshot.error}");
      }
      else{
        final choices = snapshot.data!;
        return SingleChildScrollView(scrollDirection: Axis.horizontal,
            child: DropdownButton<String>(items: choices.map((choice) {
          return DropdownMenuItem<String>(value: choice, child: Text(choice.toString()));
        }).toList(),
            onChanged: (value){
              setState(() {
                // Get the selected value
                _hintCopy = value!;
                widget.onSelect(value);
              });
            }, hint: Text(_hintCopy, style: TextStyle(color: widget.background == Colors.white ? Colors.black
                : Colors.white)),
            style: TextStyle(color: widget.background == Colors.white ?  Colors.black
                : Colors.white)));
      }
    });*/
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

  void newStock(){
    _stockWidgets.add(Stock(hintText: "Stock Central Suivant",
      column: STOCK_CENTRAL,
      background: background,
      onSelect: (value){
      objTransfert.stock_central_suivants.add(value);
      },
    ));
  }
  @override
  void initState(){
    newStock();
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
              newStock();
              print(objTransfert.stock_central_suivants);
            });
          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              child: Icon(Icons.add, color: Colors.black)),
        ]),
      );
  }
}

class Boucle extends StatefulWidget {
  final String district;
  const Boucle({super.key, required this.district});

  @override
  State<Boucle> createState() => _BoucleState();
}

class _BoucleState extends State<Boucle> {
  List<Widget> _boucle = [];

  void create_boucle(){
      _boucle.add(Stock(hintText: "Colline",
          column: DISTRICT+5,
          district: widget.district,
          background: background,
          onSelect: (value) {}
      )
      );
      _boucle.add(Stock(hintText: "Input",
          column: INPUT,
          background: background,
          onSelect: (value) {}
      )
      );
      _boucle.add(TextField(
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: "Quantité...",
        ),
      ));
  }
  @override
  void initState(){
    create_boucle();
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
            ..._boucle,
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              setState(() {
                create_boucle();
              });
            },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
                child: Icon(Icons.add, color: Colors.black)),
          ]),
    );
  }
}