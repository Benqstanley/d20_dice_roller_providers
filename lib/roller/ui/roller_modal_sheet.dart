import 'package:flutter/material.dart';

class RollerModalSheet extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final TextStyle rollerModalSheetStyle = TextStyle(fontSize: 22);

  RollerModalSheet(this.results);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: results.map((result) {
          return Container(
            decoration: BoxDecoration(border: Border(bottom:BorderSide())),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(result['collectionDescription'],
                        style: rollerModalSheetStyle)),
                Container(),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        result['expandedResult'],
                        style: rollerModalSheetStyle,
                      )),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
