import 'package:d20_dice_roller/app_theme/bloc/app_theme_bloc.dart';
import 'package:d20_dice_roller/roller/bloc/roller_screen_bloc.dart';
import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:d20_dice_roller/uikit/screen_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RollerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RollerScreenBloc rollerScreenBloc = Provider.of<RollerScreenBloc>(context);
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
              itemCount: rollerScreenBloc.collectionRows.length +
                  rollerScreenBloc.singleTypeCollections.length,
              itemBuilder: (ctx, int) {
                if (int < rollerScreenBloc.collectionRows.length) {
                  return rollerScreenBloc.collectionRows[int];
                }
                return rollerScreenBloc.singleTypeCollections[
                    int - rollerScreenBloc.collectionRows.length];
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
                  rollerScreenBloc.resetScreen();
                },
              ),
              RaisedButton(
                child: Text('Add Row'),
                onPressed: () {
                  rollerScreenBloc.addSingleTypeCollectionRow();
                },
              ),
              RaisedButton(
                child: Text('Roll'),
                onPressed: () {
                  rollerScreenBloc.rollCollections(
                    context,
                    sessionHistoryModel,
                  );
                },
              ),
              RaisedButton(
                child: Text('change'),
                onPressed: () {
                  Provider.of<AppThemeBloc>(context).requestThemeUpdate(
                      primarySwatch: Colors.blueGrey,
                      scaffoldColor: Colors.blueGrey[100]);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
