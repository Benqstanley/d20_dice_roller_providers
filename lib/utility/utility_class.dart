import 'dart:math';

import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/core/dice_types.dart';

class Utility {
  static Random random = Random();

  static List<Map<String, dynamic>> rollSingleTypeCollectionWithMultiplier(SingleTypeCollectionModel model){
    List<Map<String, dynamic>> results = [];
    int i = 1;
    for(i = 1; i <= model.multiplier; i++){
      results.add(rollSingleTypeCollection(model));
    }
    return results;
  }

  static Map<String, dynamic> rollSingleTypeCollection(SingleTypeCollectionModel model) {
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
    result['shortResult'] = rollValue;
    return result;
  }

  static Map<String, dynamic> rollNamedCollection(NamedCollectionModel model) {
    Map<String, dynamic> result = Map();
    List<Map<String, dynamic>> singleTypeResults = [];
    for(SingleTypeCollectionModel singleModel in model.singleTypeCollections){
      singleTypeResults.add(rollSingleTypeCollection(singleModel));
    }
    result["name"] = model.name;
    result["singleResults"] = singleTypeResults;
    return result;
  }

  static Map<String, dynamic> rollNamedMultiCollection(NamedMultiCollectionModel model) {
    Map<String, dynamic> result = Map();
    List<Map<String, dynamic>> namedResults = [];
    for(NamedCollectionModel namedModel in model.parts){
      namedResults.add(rollNamedCollection(namedModel));
    }
    result["name"] = model.name;
    result["namedResults"] = namedResults;
    return result;
  }

  static List<Map<String, dynamic>> rollCollectionWithMultiplier(CollectionModel model){
    List<Map<String, dynamic>> results = [];
    for(int i = 1; i <= model.multiplier; i++){
      results.add(rollCollection(model));
    }
    return results;
  }

  static Map<String, dynamic> rollCollection(CollectionModel model) {
    Map<String, dynamic> result = Map();
    if(model is NamedCollectionModel) {
      List<Map<String, dynamic>> singleTypeResults = [];
      for (SingleTypeCollectionModel singleModel in model
          .singleTypeCollections) {
        singleTypeResults.add(rollSingleTypeCollection(singleModel));
      }
      result["name"] = model.name;
      result["singleResults"] = singleTypeResults;
      return result;
    }else{
      List<Map<String, dynamic>> namedResults = [];
      for(NamedCollectionModel namedModel in model.parts){
        namedResults.add(rollCollection(namedModel));
      }
      result["name"] = model.name;
      result["namedResults"] = namedResults;
      return result;
    }
  }
}
