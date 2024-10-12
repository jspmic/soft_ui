import 'package:soft/excel_fields.dart';
import 'package:flutter/material.dart';

// Function to list all the contents of the specified column in the sheet
Future<Iterable<String?>> list(int column) async{
  Worksheet workSheet = await Worksheet.fromAsset("assets/worksheet.xlsx");
  return workSheet.readColumn("Feuille 1", column);
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
      firstDate: DateTime(1920), lastDate: DateTime(3050), initialDate: DateTime.now()
  ).then((DateTime? selected) {
    if (selected != null && selected != _date) {
      setState(() => _date = selected);
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
          const SizedBox(height: 20,),
          Text("Date: ${_date ?? "Aucune date"}",
              style: TextStyle(fontSize: 18, color: Colors.white))
        ],
      ),
    );
  }
}

// Function to return a drop-down of all the cell values in a column in the sheet
class Stock extends StatefulWidget {
  final String hintText;
  final int column;
  final Color? background;
  const Stock({super.key, required this.hintText, required this.column, required this.background});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  String _hintCopy = "Default";

  @override
  void initState(){
    _hintCopy = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<String?>>(future: list(widget.column), builder: (context, snapshot){
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
                _hintCopy = value!;
              });
            }, hint: Text(_hintCopy, style: TextStyle(color: widget.background == Colors.white ? Colors.black
                : Colors.white)),
            style: TextStyle(color: widget.background == Colors.white ?  Colors.black
                : Colors.white)));
      }
    });
  }
}