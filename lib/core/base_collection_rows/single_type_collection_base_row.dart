import 'package:d20_dice_roller/core/base_collection_models/single_type_collection_base_model.dart';
import 'package:d20_dice_roller/core/dice_types.dart';
import 'package:d20_dice_roller/roller/collection_management/collection_models/single_type_collection_roller_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleTypeCollectionBaseRow extends StatelessWidget {
  final Function onDismissed;
  final Function handleCheckbox;
  final Key key = UniqueKey();
  final SingleTypeCollectionBaseModel collectionModel;

  SingleTypeCollectionBaseRow(
    this.onDismissed,
    this.collectionModel, {
    this.handleCheckbox,
  });

  @override
  Widget build(BuildContext context) {
    bool needsCheckbox = collectionModel is SingleTypeCollectionRollerModel;
    return ChangeNotifierProvider.value(
      value: collectionModel,
      key: key,
      child: SingleTypeCollectionBaseRowContents(
        needsCheckbox,
        (_) => onDismissed(this),
        handleCheckBoxChange: handleCheckbox,
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

  SingleTypeCollectionBaseRowContents(this.needsCheckbox, this.onDismissed,
      {this.handleCheckBoxChange})
      : assert(!needsCheckbox || handleCheckBoxChange != null);

  @override
  Widget build(BuildContext context) {
    SingleTypeCollectionBaseModel collectionModel =
        Provider.of<SingleTypeCollectionBaseModel>(context);
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
    return Dismissible(
      key: UniqueKey(),
      onDismissed: onDismissed,
      background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
              child: ListTile(
            trailing: Icon(Icons.delete),
            leading: Icon(Icons.delete),
          ))),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
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
                Expanded(
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
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
