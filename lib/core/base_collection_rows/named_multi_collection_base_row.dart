import 'package:d20_dice_roller/core/base_collection_models/named_multi_collection_base_model.dart';
import 'package:d20_dice_roller/named_collections/choose_named_collection/collection_management/collection_models/named_multi_collection_choose_model.dart';
import 'package:d20_dice_roller/roller/collection_management/collection_models/named_multi_collection_roller_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TrailingSelector { checkbox, checkboxToCounter, none }

class NamedMultiCollectionBaseRow extends StatelessWidget {
  final NamedMultiCollectionBaseModel collectionModel;
  final Function onDismissed;
  final Function handleIncrement;
  final Function handleDecrement;
  final Function handleCheckboxChanged;

  NamedMultiCollectionBaseRow(
    this.collectionModel,
    this.onDismissed, {
    this.handleIncrement,
    this.handleDecrement,
    this.handleCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    TrailingSelector selector;
    if(collectionModel is NamedMultiCollectionRollerModel){
      selector = TrailingSelector.checkbox;
    }
    if(collectionModel is NamedMultiCollectionChooseModel){
      selector = TrailingSelector.checkboxToCounter;
    }
    return ChangeNotifierProvider.value(
      value: collectionModel,
      child: NamedMultiCollectionBaseRowContents(
        (_) => onDismissed(this),
        selector,
        handleCheckboxChanged: handleCheckboxChanged,
        handleDecrement: handleDecrement,
        handleIncrement: handleIncrement,
      ),
    );
  }

  @override
  String toStringShort() {
    return collectionModel.name;
  }
}

class NamedMultiCollectionBaseRowContents extends StatelessWidget {
  final UniqueKey key = UniqueKey();
  final Function onDismissed;
  final Function handleCheckboxChanged;
  final Function handleIncrement;
  final Function handleDecrement;
  final TrailingSelector selector;

  NamedMultiCollectionBaseRowContents(
    this.onDismissed,
    this.selector, {
    this.handleCheckboxChanged,
    this.handleIncrement,
    this.handleDecrement,
  })  : assert(selector == TrailingSelector.none ||
            handleCheckboxChanged != null ||
            handleIncrement != null ||
            handleDecrement != null),
        assert(selector != TrailingSelector.checkbox ||
            handleCheckboxChanged != null),
        assert(selector != TrailingSelector.checkboxToCounter ||
            (handleIncrement != null &&
                handleDecrement != null &&
                handleCheckboxChanged != null));

  @override
  Widget build(BuildContext context) {
    NamedMultiCollectionBaseModel model =
        Provider.of<NamedMultiCollectionBaseModel>(context);
    String counterState;
    bool checkBox;
    if (selector == TrailingSelector.checkboxToCounter) {
      counterState = model.counterState.toString();
    }
    if (selector != TrailingSelector.none) {
      checkBox = model.checkBox;
    }
    return Dismissible(
      key: key,
      onDismissed: onDismissed,
      background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
              child: ListTile(
            leading: Icon(Icons.delete),
            trailing: Icon(Icons.delete),
          ))),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                model.name + ":",
                style: TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: model.parts
                          .map((singleTypeCollection) => Text(
                                singleTypeCollection.toString(),
                                style: TextStyle(fontSize: 16),
                              ))
                          .toList(),
                    ),
                  ),
                  selector == TrailingSelector.none
                      ? Container(
                          width: 0,
                        )
                      : buildTrailing(checkBox, counterState),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTrailing(bool checkBoxValue, String counterState) {
    if (selector == TrailingSelector.checkbox || !checkBoxValue) {
      return Checkbox(
        value: checkBoxValue,
        onChanged: handleCheckboxChanged,
      );
    } else {
      return Flexible(
        flex: 1,
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: FlatButton(
                child: Text('-'),
                onPressed: handleDecrement,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsets.all(4),
                decoration:
                    BoxDecoration(border: Border.all(), color: Colors.white),
                child: Text(counterState),
              ),
            ),
            Flexible(
              flex: 2,
              child: FlatButton(
                child: Text('+'),
                onPressed: handleIncrement,
              ),
            )
          ],
        ),
      );
    }
  }
}
