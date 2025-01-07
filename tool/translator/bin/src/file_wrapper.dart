import 'dart:io';
import 'app.dart';

class FileWrapper implements IFileWrapper {
  final File _file;

  FileWrapper(String path) : _file = File(path);

  FileWrapper.fromFile(this._file);

  @override
  Future<String> readAsString() async {
    return await _file.readAsString();
  }

  @override
  Future<void> writeAsString(String content) async {
    await _file.writeAsString(content);
  }

  @override
  String get path => _file.path;

  @override
  Future<int> length() => _file.length();

  @override
  Future<List<String>> readAsLines() async {
    return await _file.readAsLines();
  }

  @override
  bool exists() => _file.existsSync(); 
  
}

