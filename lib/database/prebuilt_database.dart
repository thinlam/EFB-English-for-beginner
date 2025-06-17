import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle, ByteData;

Future<Database> openPrebuiltDB() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'efb_db.sqlite');

  print('📂 App đang dùng file DB tại: $path');

  if (!await File(path).exists()) {
    ByteData data = await rootBundle.load('assets/database/efb_db.sqlite');
    final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);
  }

  return openDatabase(path);
}
