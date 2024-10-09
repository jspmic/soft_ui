import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';

// Columns refactor
const STOCK_CENTRAL = 1;
const LIVRAISON_RETOUR = 2;
const INPUT = 3;
const PROGRAM = 4;
const TYPE_TRANSPORT = 5;
const DISTRICT = 6;

class Worksheet{
  late Excel excel;

  Worksheet(Uint8List bytes){
    excel = Excel.decodeBytes(bytes);
  }

  static Future<Worksheet> fromAsset(String filePath) async{
    ByteData data = await rootBundle.load(filePath);
    Uint8List bytes = data.buffer.asUint8List();
    return Worksheet(bytes);
  }

  List<String?> readColumn(String sheetName, int column){
    List<String?> columnContent = [];
    Sheet sheet = excel[sheetName];

    for (var row in sheet.rows){
      String? rowValue = row[column-1]?.value.toString();
      if (rowValue != null.toString()){
        columnContent.add(rowValue);
      }
    }
    return columnContent;
  }
}