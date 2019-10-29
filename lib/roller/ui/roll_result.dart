import 'package:flutter/material.dart';

class RollResult extends StatelessWidget {
  TextStyle rollResultStyle;
  Map<String, dynamic> result;
  RollResult(this.result, this.rollResultStyle);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom:BorderSide())),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(result['collectionDescription'],
                  style: rollResultStyle)),
          Container(),
          Flexible(
            child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  result['expandedResult'],
                  style: rollResultStyle,
                )),
          ),
        ],
      ),
    );
  }
}
