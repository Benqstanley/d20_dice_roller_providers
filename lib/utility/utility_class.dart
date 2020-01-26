import 'dart:math';

import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/core/dice_types.dart';

class Utility {
  static Random random = Random();

  static List<Map<String, dynamic>> rollSingleTypeCollectionWithMultiplier(
      SingleTypeCollectionModel model) {
    List<Map<String, dynamic>> results = [];
    int i = 1;
    bool hasMult = model.multiplier > 1;
    for (i = 1; i <= model.multiplier; i++) {
      results
          .add(rollSingleTypeCollection(model, instance: hasMult ? i : null));
    }
    return results;
  }

  static Map<String, dynamic> rollSingleTypeCollection(
      SingleTypeCollectionModel model,
      {int instance}) {
    StringBuffer expandedResultBuffer = StringBuffer();
    int rollValue = 0;
    Map<String, dynamic> result = Map();
    for (int k = 0; k < model.numberOfDice; k++) {
      int currentDiceRoll = (random.nextInt(diceTypeInts[model.diceType]) + 1);
      rollValue = rollValue + currentDiceRoll;
      expandedResultBuffer.write(" + $currentDiceRoll");
    }
    if (model.modifier != null && model.modifier != 0) {
      rollValue = rollValue + model.modifier;
      expandedResultBuffer.write(" + ${model.modifier}");
    }
    expandedResultBuffer.write(" = $rollValue");
    String expandedResult = expandedResultBuffer.toString().substring(3);
    String instanceAddOn = instance != null ? " ($instance)" : "";
    result['collectionDescription'] = model.toStringForRoller() + instanceAddOn;
    result['expandedResult'] = expandedResult;
    result['shortResult'] = rollValue;
    return result;
  }

  static List<Map<String, dynamic>> rollCollectionWithMultiplier(
      CollectionModel model) {
    bool hasMult = model.multiplier > 1;
    List<Map<String, dynamic>> results = [];
    for (int i = 1; i <= model.multiplier; i++) {
      results.add(rollCollection(model, instance: hasMult ? i : null));
    }
    return results;
  }

  static Map<String, dynamic> rollCollection(CollectionModel model,
      {int instance}) {
    Map<String, dynamic> result = Map();
    if (model is NamedCollectionModel) {
      List<Map<String, dynamic>> singleTypeResults = [];
      for (SingleTypeCollectionModel singleModel
          in model.singleTypeCollections) {
        singleTypeResults
            .addAll(rollSingleTypeCollectionWithMultiplier(singleModel));
      }
      String instanceAddOn = instance != null ? " ($instance)" : "";
      result["name"] = model.name + instanceAddOn;
      result["singleResults"] = singleTypeResults;
      return result;
    } else {
      List<Map<String, dynamic>> namedResults = [];
      for (NamedCollectionModel namedModel in model.parts) {
        namedResults.addAll(rollCollectionWithMultiplier(namedModel));
      }
      result["name"] = model.name;
      result["namedResults"] = namedResults;
      return result;
    }
  }
}
