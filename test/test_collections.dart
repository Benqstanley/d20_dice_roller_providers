import 'dart:convert';

import 'package:d20_dice_roller/core/base_collection_models/named_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';

class TestCollections {
  static String namedCollectionTestString =
      '''{"name":"Check One","multiplier":2,"singleTypeCollections":[{"numberOfDice":2,"diceType":"d6","modifier":12,"multiplier":1}]}''';
  static String namedMultiCollectionTestString =
      '''{"name":"Check Two","parts":[{"name":"Part 1","multiplier":2,"singleTypeCollections":[{"numberOfDice":3,"diceType":"d6","modifier":23,"multiplier":2}]},{"name":"Part 2","multiplier":1,"singleTypeCollections":[{"numberOfDice":12,"diceType":"d6","modifier":23,"multiplier":1}]}],"multiplier":2}''';

  static get testNamedCollection =>
      NamedCollectionModel.fromJson(json.decode(namedCollectionTestString));

  static get testNamedMultiCollection => NamedMultiCollectionModel.fromJson(
      json.decode(namedMultiCollectionTestString), "");
}
