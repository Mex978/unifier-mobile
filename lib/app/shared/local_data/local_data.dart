import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalData {
  static final String _filename = 'token';

  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$_filename.txt");
  }

  static Future<String> readToken() async {
    try {
      final file = await _getFile();
      if (await file.exists()) return await file.readAsString();
    } catch (e) {}

    return '';
  }

  static Future<void> saveToken(String token) async {
    final file = await _getFile();
    await file.writeAsString(token);
  }
}
