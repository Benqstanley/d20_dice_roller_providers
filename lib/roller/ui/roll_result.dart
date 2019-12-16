import 'package:flutter/material.dart';

class RollResult extends StatelessWidget {
  final TextStyle rollResultStyle;
  final Map<String, dynamic> result;
  final TextStyle subStyle;

  RollResult(this.result, this.rollResultStyle, {this.subStyle});

  Widget buildNamedResult() {
    List<Widget> singleResults = [];
    singleResults.add(Text(result["name"], style: rollResultStyle,));
    for (Map<String, dynamic> singleResult in result["singleResults"]) {
      singleResults.add(RollResult(singleResult, subStyle));
    }
    return Column(children: singleResults);
  }

  Widget buildNamedMultiResult() {
    return Container(child: Text("multi"));
  }

  Widget buildSingleResult() {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (result.containsKey("expandedResult")) {
      return buildSingleResult();
    } else if (result.containsKey("singleResults")) {
      return buildNamedResult();
    } else {
      return buildNamedMultiResult();
    }
  }
}
