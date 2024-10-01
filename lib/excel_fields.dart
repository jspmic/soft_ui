import 'dart:io';
import 'package:path/path.dart';
import 'package:excel_dart/excel_dart.dart';

int main() {
  bool set = false;
  const int STOCK_CENTRAL = 0;
  const int LIVRAISON_RETOUR = 1;
  const int INPUT = 2;
  const int PROGRAM = 3;
  const int TYPE_TRANSPORT = 4;
  const int DISTRICT = 5;
  const int COLLINE = DISTRICT + 1;
  var sheet = Worksheet(filename: FILENAME);
  List stock_central = [];
  List input = [];
  List type_transport = [];
  List district = [];
  Map<String, String> collines = {};
  Map tables = sheet.initialize();
  int count = 0;
  int actual_row = 0;
  for (var table in tables.keys) {
    var maxcols = tables[table].maxCols;
    // print("Max cols: $maxcols");
    var rows = tables[table].rows;
    for (var row in rows) {
      if (actual_row != 0) {
        for (var col in Iterable.generate(maxcols)) {
          if (row[col] != null) {
            switch (col) {
              case STOCK_CENTRAL:
                stock_central.add(row[col].value);
                break;
              case LIVRAISON_RETOUR:
                break;
              case INPUT:
                input.add(row[col].value);
                break;
              case PROGRAM:
                break;
              case TYPE_TRANSPORT:
                type_transport.add(row[col].value);
                break;
              case DISTRICT:
                district.add(row[col].value);
                break;
              default:
                // print(row[col].value);
                break;
            }
          }
        }
      }
      actual_row += 1;
    }
  }
  print(stock_central);
  return 0;
}

String FILENAME = "./worksheet.xlsx";

class Worksheet {
  String filename = FILENAME;
  var table;
  Worksheet({required String filename});

  Map initialize() {
    var bytes = File(filename.toString()).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    table = excel.tables;
    return table;
  }
}
