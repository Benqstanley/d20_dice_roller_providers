import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

abstract class CreateModel extends ChangeNotifier{
  Future<String>  localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> saveCollection();
}