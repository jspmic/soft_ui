import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';

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
      columnContent.add(row[column-1]?.value.toString());
    }
      return columnContent;
  }
}