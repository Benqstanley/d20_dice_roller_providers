import 'package:d20_dice_roller/roller/model/single_type_collection_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleTypeCollectionRow extends StatelessWidget {
  final Function onDismissed;
  final Key key = UniqueKey();
  final collectionModel = SingleTypeCollectionModel();
  SingleTypeCollectionRow(this.onDismissed,);

  @override
  Widget build(BuildContext context) {
    collectionModel.onDismissed = () => onDismissed(this);
    return ChangeNotifierProvider.value(
      value: collectionModel,
      key: key,
      child: SingleTypeCollectionRowContents(),
    );
  }
}

class SingleTypeCollectionRowContents extends StatelessWidget {
  final TextEditingController numberOfDiceController = TextEditingController();
  final TextEditingController modifierController = TextEditingController();
  final double spacing = 4;

  @override
  Widget build(BuildContext context) {
    SingleTypeCollectionModel collectionModel =
        Provider.of<SingleTypeCollectionModel>(context);
    numberOfDiceController.addListener(() {
      collectionModel.numberOfDice = int.tryParse(numberOfDiceController.text);
    });
    modifierController.addListener(() {
      collectionModel.modifier = int.tryParse(modifierController.text);
    });
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => collectionModel.onDismissed(),
      background: Container(
          color: Colors.red,
          child: Center(
              child: ListTile(
            trailing: Icon(Icons.delete),
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
                    collectionModel.setType(type);
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
                Column(
                  children: <Widget>[
                    Text('Roll'),
                    Checkbox(
                      value: collectionModel.toRoll,
                      onChanged: (newValue) {
                        collectionModel.toRoll = newValue;
                      },
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
