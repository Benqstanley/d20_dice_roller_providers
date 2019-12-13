import 'dart:math';

import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_base_model.dart';
import 'package:d20_dice_roller/core/single_type_collection_model.dart';

class Utility {
  static Random random = Random();

  static Map<String, dynamic> rollSingleTypeCollection(SingleTypeCollectionBaseModel model) {
    StringBuffer expandedResultBuffer = StringBuffer();
    int rollValue = 0;
    Map<String, dynamic> result = Map();
    for (int k = 0; k < model.numberOfDice; k++) {
      int currentDiceRoll = (random.nextInt(diceTypeInts[model.diceType]) + 1);
      rollValue =
          rollValue + currentDiceRoll;
      expandedResultBuffer.write(" + $currentDiceRoll");
    }
    if(model.modifier != null && model.modifier != 0){
      rollValue = rollValue + model.modifier;
      expandedResultBuffer.write(" + ${model.modifier}");
    }
    expandedResultBuffer.write(" = $rollValue");
    String expandedResult = expandedResultBuffer.toString().substring(3);
    result['collectionDescription'] = model.toString();
    result['expandedResult'] = expandedResult;
    result['rollValue'] = rollValue;
    return result;
  }
}
