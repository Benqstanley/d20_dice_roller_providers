import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/core/base_collection_rows/single_type_collection_row.dart';

class CreateNamedMultiTypeCollectionModel extends NamedMultiCollectionModel {
  String name;
  List<SingleTypeCollectionRow> singleTypeCollections = [];
  var dismissRow;

  CreateNamedMultiTypeCollectionModel(Function dismiss) {
    dismissRow = (SingleTypeCollectionRow toBeDismissed) =>
        dismiss(toBeDismissed, model: this);
    addSingleTypeCollectionRow();
  }

  void resetList() {
    singleTypeCollections = [];
    addSingleTypeCollectionRow();
  }

  void addSingleTypeCollectionRow() {
    singleTypeCollections.add(SingleTypeCollectionRow(
      SingleTypeCollectionModel(),
      dismissRow,
    ));
  }

  @override
  String toString() {
    return name;
  }
}
