import 'package:d20_dice_roller/session_history/model/session_history_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SessionHistoryModel sessionHistoryModel =
        Provider.of<SessionHistoryModel>(context);
    bool hasHistory = sessionHistoryModel.sessionResults.isNotEmpty;
    return hasHistory
        ? buildWidgetWithHistory(context, sessionHistoryModel)
        : buildNoHistoryWidget(context);
  }

  Widget buildWidgetWithHistory(
    BuildContext context,
    SessionHistoryModel sessionHistoryModel,
  ) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(),
                ),
              ),
              child: Center(
                child: Text(
                  "Session History",
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, k) =>
                    sessionHistoryModel.sessionResultsWidgets()[k],
                separatorBuilder: (context, j) => Divider(),
                itemCount: sessionHistoryModel.sessionResults.length),
          ],
        ));
  }

  Widget buildNoHistoryWidget(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("No History Yet", style: Theme.of(context).textTheme.display1),
            RaisedButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
              child: Text("Go Roll Some Dice!"),
            )
          ],
        ),
      ),
    );
  }
}
