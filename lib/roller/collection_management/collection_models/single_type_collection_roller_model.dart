import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_base_model.dart';

class SingleTypeCollectionRollerModel extends SingleTypeCollectionBaseModel{

  void changeCheckbox(bool newValue){
    checkBox = newValue;
    notifyListeners();
  }

}