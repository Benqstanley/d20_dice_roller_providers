import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_model.dart';
import 'package:d20_dice_roller/core/mult_counter.dart';
import 'package:d20_dice_roller/core/dice_types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleTypeCollectionRow extends StatelessWidget {
  final Function onDismissed;
  final Function handleCheckbox;
  final Key key = UniqueKey();
  final SingleTypeCollectionModel collectionModel;
  final bool forCreate;

  SingleTypeCollectionRow(this.collectionModel, this.onDismissed,
      {this.handleCheckbox, this.forCreate = false});

  factory SingleTypeCollectionRow.forCreate(
    SingleTypeCollectionModel collectionModel,
    Function onDismissed,
  ) {
    collectionModel = collectionModel ?? SingleTypeCollectionModel();
    return SingleTypeCollectionRow(
      collectionModel,
      onDismissed,
      forCreate: true,
    );
  }

  factory SingleTypeCollectionRow.forRoller(
    SingleTypeCollectionModel collectionModel,
    Function onDismissed,
  ) {
    return SingleTypeCollectionRow(
      collectionModel,
      onDismissed,
      handleCheckbox: collectionModel.changeCheckbox,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool needsCheckbox = handleCheckbox != null;
    return ChangeNotifierProvider.value(
      value: collectionModel,
      key: key,
      child: SingleTypeCollectionBaseRowContents(
        needsCheckbox,
        (_) => onDismissed(collectionModel),
        handleCheckBoxChange: handleCheckbox,
        forCreate: forCreate,
      ),
    );
  }
}

class SingleTypeCollectionBaseRowContents extends StatelessWidget {
  final TextEditingController numberOfDiceController = TextEditingController();
  final TextEditingController modifierController = TextEditingController();
  final Function onDismissed;
  final Function handleCheckBoxChange;
  final double spacing = 4;
  final bool needsCheckbox;
  final bool forCreate;

  SingleTypeCollectionBaseRowContents(
    this.needsCheckbox,
    this.onDismissed, {
    this.handleCheckBoxChange,
    this.forCreate = false,
  })  : assert(!needsCheckbox || handleCheckBoxChange != null),
        assert(!needsCheckbox || !forCreate);

  @override
  Widget build(BuildContext context) {
    SingleTypeCollectionModel collectionModel =
        Provider.of<SingleTypeCollectionModel>(context);
    if (collectionModel.numberOfDice != null) {
      numberOfDiceController.text = collectionModel.numberOfDice.toString();
    }
    if (collectionModel.modifier != null) {
      modifierController.text = collectionModel.modifier.toString();
    }
    numberOfDiceController.addListener(() {
      collectionModel.numberOfDice = int.tryParse(numberOfDiceController.text);
    });
    modifierController.addListener(() {
      collectionModel.modifier = int.tryParse(modifierController.text);
    });
    return Card(
      elevation: 5,
      color: Theme.of(context).backgroundColor,
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: onDismissed,
        background: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).errorColor,
            ),
            child: Center(
                child: ListTile(
              trailing: Icon(Icons.delete),
              leading: Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              ),
            ))),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(hintText: "# of Dice"),
                          controller: numberOfDiceController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: spacing,
                      ),
                      Icon(Icons.close),
                      SizedBox(
                        width: spacing,
                      ),
                      DropdownButton<DiceType>(
                        hint: Text("Type"),
                        value: collectionModel.diceType,
                        onChanged: (DiceType type) {
                          collectionModel.updateWith(diceType: type);
                        },
                        items: diceTypes
                            .map((type) => DropdownMenuItem<DiceType>(
                                  value: type,
                                  child: Text(diceTypeStrings[type]),
                                ))
                            .toList(),
                      ),
                      SizedBox(
                        width: spacing,
                      ),
                      Icon(Icons.add),
                      SizedBox(
                        width: spacing,
                      ),
                      Flexible(
                        fit: forCreate ? FlexFit.loose : FlexFit.tight,
                        child: TextField(
                          decoration: InputDecoration(hintText: "Modifier"),
                          controller: modifierController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      if (needsCheckbox)
                        Column(
                          children: <Widget>[
                            Text('Roll'),
                            Checkbox(
                              value: collectionModel.checkBox,
                              onChanged: handleCheckBoxChange,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (forCreate)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      height: 72,
                      width: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(Icons.close, size: 20,),
                    SizedBox(
                      width: 8,
                    ),
                    MultCounter(
                      collectionModel.multiplier.toString(),
                      context,
                      handleCheckboxChanged: collectionModel.changeCheckbox,
                      checkBoxValue: true,
                      handleIncrement: collectionModel.incrementMultiplier,
                      handleDecrement: collectionModel.decrementMultiplier,
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
