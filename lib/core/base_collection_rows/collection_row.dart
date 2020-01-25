import 'package:d20_dice_roller/core/base_collection_models/collection_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ScreenSelector { rollerScreen, chooseCollections, createScreen }

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
    Function handleIncrement,
    Function handleDecrement,
  ) {
    collectionModel.checkBox = true;
    return CollectionRow(
      collectionModel,
      onDismissed,
      ScreenSelector.createScreen,
      handleEdit: handleEdit,
      handleIncrement: handleIncrement,
      handleDecrement: handleDecrement,
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
      T collectionModel, Function onDismissed, Function handleEdit) {
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
    if (selector == ScreenSelector.chooseCollections) {
      counterState = model.counterState.toString();
    } else if (selector == ScreenSelector.createScreen) {
      counterState = model.multiplier.toString();
    }
    checkBox = model.checkBox;

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
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(border: Border.all()),
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
                            model.name + ":",
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
              Icon(Icons.close),
              SizedBox(width: 8,),
              buildTrailing(
                checkBox,
                counterState,
                context,
              ),
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
    if (selector == ScreenSelector.rollerScreen || !checkBoxValue) {
      return Container(
        height: 66,
        child: Center(
          child: Checkbox(
            value: checkBoxValue,
            onChanged: handleCheckboxChanged,
          ),
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide()),
                  color: Theme.of(context).backgroundColor),
              child: Text(counterState),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: MultButton(
                    text: '+',
                    onTap: handleIncrement,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Flexible(
                  flex: 2,
                  child: MultButton(
                    text: '-',
                    onTap: () {
                      handleDecrement();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}

class MultButton extends StatelessWidget {
  final Function onTap;
  final String text;

  MultButton({
    this.onTap,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Theme.of(context).buttonColor,
        border: Border.all(),
      ),
      height: 30,
      width: 50,
      child: InkWell(
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
