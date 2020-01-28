import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

abstract class CreateModel extends ChangeNotifier{
  int multiplier = 1;
  final TextEditingController nameController = TextEditingController();

  void incrementMultiplier(){
    multiplier++;
    notifyListeners();
  }

  void decrementMultiplier(){
    if(multiplier > 1){
      multiplier--;
      notifyListeners();
    }
  }

  Future<String>  localPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> saveCollection();
}