
import 'package:d20_dice_roller/roller/ui/single_type_collection_row.dart';

class NamedMultiTypeCollectionModel {
  String name;
  List<SingleTypeCollectionRow> singleTypeCollections = [];
  var dismissRow;

  NamedMultiTypeCollectionModel(Function dismiss) {
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
      dismissRow,
      needsCheckbox: false,
    ));
  }
}