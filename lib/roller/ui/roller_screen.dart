import 'package:d20_dice_roller/roller/model/roller_screen_model.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:d20_dice_roller/uikit/screen_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RollerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RollerScreenModel rollerScreenModel =
        Provider.of<RollerScreenModel>(context);
    SessionHistoryModel sessionHistoryModel =
        Provider.of<SessionHistoryModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Dice to Roll"),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: rollerScreenModel.namedMultiCollections.length +
                  rollerScreenModel.singleTypeCollections.length,
              itemBuilder: (ctx, int) {
                if (int < rollerScreenModel.namedMultiCollections.length) {
                  return rollerScreenModel.namedMultiCollections[int];
                }
                return rollerScreenModel.singleTypeCollections[
                    int - rollerScreenModel.namedMultiCollections.length];
              },
            ),
          ),
          ScreenDivider(),
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
                  rollerScreenModel.rollCollections(
                    context,
                    sessionHistoryModel,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
