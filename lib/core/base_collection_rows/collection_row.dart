import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:d20_dice_roller/core/mult_counter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ScreenSelector {
  rollerScreen,
  chooseCollections,
  createScreen,
}

class CollectionRow<T extends CollectionModel> extends StatelessWidget {
  final T collectionModel;
  final Function onDismissed;
  final Function handleIncrement;
  final Function handleDecrement;
  final Function handleCheckboxChanged;
  final Function handleEdit;
  final ScreenSelector selector;

  CollectionRow(
    this.collectionModel,
    this.onDismissed,
    this.selector, {
    this.handleCheckboxChanged,
    this.handleDecrement,
    this.handleIncrement,
    this.handleEdit,
  });

  factory CollectionRow.forCreate(
    T collectionModel,
    Function onDismissed,
    Function handleEdit,
  ) {
    collectionModel.checkBox = true;
    return CollectionRow(
      collectionModel,
      onDismissed,
      ScreenSelector.createScreen,
      handleEdit: handleEdit,
      handleIncrement: collectionModel.incrementMultiplier,
      handleDecrement: collectionModel.decrementMultiplier,
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
      ScreenSelector.rollerScreen,
      handleCheckboxChanged: collectionModel.changeCheckbox,
    );
  }

  factory CollectionRow.forChoose(
    T collectionModel,
    Function onDismissed,
    Function handleEdit,
  ) {
    collectionModel.checkBox = false;
    return CollectionRow(
      collectionModel,
      onDismissed,
      ScreenSelector.chooseCollections,
      handleCheckboxChanged: collectionModel.changeCheckbox,
      handleIncrement: collectionModel.increment,
      handleDecrement: collectionModel.decrement,
      handleEdit: handleEdit,
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
        handleEdit: handleEdit,
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
  final Function handleEdit;
  final ScreenSelector selector;

  CollectionRowContents(
    this.onDismissed,
    this.selector, {
    this.handleCheckboxChanged,
    this.handleIncrement,
    this.handleDecrement,
    this.handleEdit,
  })  : assert(selector == ScreenSelector.createScreen ||
            handleCheckboxChanged != null ||
            handleIncrement != null ||
            handleDecrement != null),
        assert(selector != ScreenSelector.rollerScreen ||
            handleCheckboxChanged != null),
        assert(selector != ScreenSelector.chooseCollections ||
            (handleIncrement != null &&
                handleDecrement != null &&
                handleCheckboxChanged != null)),
        assert(handleEdit != null || selector == ScreenSelector.rollerScreen);

  @override
  Widget build(BuildContext context) {
    T model = Provider.of<T>(context);
    String counterState;
    bool checkBox;
    bool forCreate = selector == ScreenSelector.createScreen;
    if (selector == ScreenSelector.chooseCollections) {
      counterState = model.counterState.toString();
    } else if (forCreate) {
      counterState = model.multiplier.toString();
    }
    checkBox = model.checkBox;
    String multiplierAddOn =
        model.multiplier > 1 ? " (${model.multiplier})" : "";
    return Card(
      elevation: 5,
      color: Theme.of(context).backgroundColor,
      child: Dismissible(
        key: key,
        onDismissed: (_) => onDismissed(model),
        background: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).errorColor,
            ),
            child: Center(
                child: ListTile(
              leading: Text(
                selector == ScreenSelector.rollerScreen ? "Remove" : "Delete",
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.delete),
            ))),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all()),
          child: Padding(
            padding: selector == ScreenSelector.rollerScreen
                ? const EdgeInsets.fromLTRB(8, 0, 0, 0)
                : EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                selector == ScreenSelector.chooseCollections ||
                        selector == ScreenSelector.createScreen
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Icon(Icons.edit),
                          onTap: () {
                            handleEdit();
                          },
                        ),
                      )
                    : Container(),
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              model.name + ":" + multiplierAddOn,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
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
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    if (forCreate)
                      Container(
                        height: 74,
                        width: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    SizedBox(
                      width: 4,
                    ),
                    if (selector != ScreenSelector.rollerScreen && checkBox)
                      Icon(
                        Icons.close,
                        size: 20,
                      ),
                    SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MultCounter(
                        counterState,
                        context,
                        showCheckBox:
                            selector == ScreenSelector.chooseCollections,
                        handleCheckboxChanged:
                            selector == ScreenSelector.chooseCollections ||
                                    selector == ScreenSelector.rollerScreen
                                ? handleCheckboxChanged
                                : null,
                        checkBoxValue: forCreate ? true : checkBox,
                        handleIncrement: handleIncrement,
                        handleDecrement: handleDecrement,
                        forRoller: selector == ScreenSelector.rollerScreen,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
