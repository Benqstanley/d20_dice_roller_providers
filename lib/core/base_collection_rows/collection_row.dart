import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TrailingSelector { checkbox, checkboxToCounter, none }

class CollectionRow<T extends CollectionModel> extends StatelessWidget {
  final T collectionModel;
  final Function onDismissed;
  final Function handleIncrement;
  final Function handleDecrement;
  final Function handleCheckboxChanged;
  final TrailingSelector selector;

  CollectionRow(
    this.collectionModel,
    this.onDismissed,
    this.selector, {
    this.handleCheckboxChanged,
    this.handleDecrement,
    this.handleIncrement,
  });

  factory CollectionRow.forCreate(
    T collectionModel,
    Function onDismissed,
  ) {
    return CollectionRow(
      collectionModel,
      onDismissed,
      TrailingSelector.none,
    );
  }

  factory CollectionRow.forRoller(
    T collectionModel,
    Function onDismissed,
  ) {
    collectionModel.checkBox = true;
    return CollectionRow(
      collectionModel,
      onDismissed,
      TrailingSelector.checkbox,
      handleCheckboxChanged: collectionModel.changeCheckbox,
    );
  }

  factory CollectionRow.forChoose(
    T collectionModel,
    Function onDismissed,
  ) {
    collectionModel.checkBox = false;
    return CollectionRow(
      collectionModel,
      onDismissed,
      TrailingSelector.checkboxToCounter,
      handleCheckboxChanged: collectionModel.changeCheckbox,
      handleIncrement: collectionModel.increment,
      handleDecrement: collectionModel.decrement,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: collectionModel,
      child: CollectionRowContents<T>(
        (_) => onDismissed(collectionModel),
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

class CollectionRowContents<T extends CollectionModel> extends StatelessWidget {
  final UniqueKey key = UniqueKey();
  final Function onDismissed;
  final Function handleCheckboxChanged;
  final Function handleIncrement;
  final Function handleDecrement;
  final TrailingSelector selector;

  CollectionRowContents(
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
    T model = Provider.of<T>(context);
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
            color: Theme.of(context).errorColor,
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
                      children: model.singleTypeCollections != null
                          ? model.singleTypeCollections
                              .map((singleTypeCollection) => Text(
                                    singleTypeCollection.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ))
                              .toList()
                          : model.parts
                              .map((part) => Text(
                                    part.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ))
                              .toList(),
                    ),
                  ),
                  selector == TrailingSelector.none
                      ? Container(
                          width: 0,
                        )
                      : buildTrailing(
                          checkBox,
                          counterState,
                          context,
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTrailing(
    bool checkBoxValue,
    String counterState,
    BuildContext context,
  ) {
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
                decoration: BoxDecoration(
                    border: Border.all(),
                    color: Theme.of(context).scaffoldBackgroundColor),
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
