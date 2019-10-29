import 'package:d20_dice_roller/roller/model/roller_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RollerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RollerScreenModel>(
      builder: (context) => RollerScreenModel(),
      child: RollerScreenContents(),
    );
  }
}


class RollerScreenContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RollerScreenModel rollerScreenModel =
        Provider.of<RollerScreenModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Dice to Roll"),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rollerScreenModel.singleTypeCollections.length,
              itemBuilder: (ctx, int) {
                return rollerScreenModel.singleTypeCollections[int];
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              RaisedButton(
                child: Text('Clear'),
                onPressed: () {
                  rollerScreenModel.resetScreen();
                },
              ),
              RaisedButton(
                child: Text('Add Row'),
                onPressed: () {
                  rollerScreenModel.addSingleTypeCollectionRow();
                },
              ),
              RaisedButton(
                child: Text('Roll'),
                onPressed: () {
                  rollerScreenModel.rollCollections(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
