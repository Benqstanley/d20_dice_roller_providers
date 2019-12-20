import 'package:flutter/material.dart';

class RollResult extends StatelessWidget {
  final TextStyle rollResultStyle;
  final Map<String, dynamic> result;
  final TextStyle subStyle;
  final bool subPart;
  final bool partOfMulti;
  final spacer = SizedBox(
    height: 8,
  );

  RollResult(
    this.result,
    this.rollResultStyle, {
    this.subStyle,
    this.subPart = false,
    this.partOfMulti = false,
  });

  Widget buildNamedResult(
    Map<String, dynamic> namedResult,
  ) {
    List<Widget> singleResults = [];
    singleResults.add(
      Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 4),
        decoration: !subPart
            ? BoxDecoration(border: Border(bottom: BorderSide()))
            : BoxDecoration(),
        child: Text(
          namedResult["name"],
          style: !subPart ? rollResultStyle : subStyle,
        ),
      ),
    );
    if (subPart) singleResults.add(Divider());
    for (Map<String, dynamic> singleResult in namedResult["singleResults"]) {
      singleResults.add(RollResult(
        singleResult,
        subStyle,
        subPart: true,
        partOfMulti: partOfMulti,
      ));
    }
    if (!subPart) singleResults.add(spacer);
    return Column(
      crossAxisAlignment:
          subPart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: singleResults,
    );
  }

  Widget buildNamedMultiResult() {
    List<Widget> namedResults = [];
    namedResults.add(Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      child: Text(
        result["name"],
        style: rollResultStyle,
      ),
    ));
    for (Map<String, dynamic> collectionResult in result["namedResults"]) {
      namedResults.add(RollResult(
        collectionResult,
        subStyle,
        subStyle: subStyle,
        subPart: true,
        partOfMulti: true,
      ));
    }
    namedResults.add(spacer);
    return Column(
      children: namedResults,
    );
  }

  Widget buildSingleResult() {
    final double leftPadding = partOfMulti ? 20 : 4;
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(leftPadding, 4, 4, 4),
              child: Text(result['collectionDescription'] + ":  ",
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
      return buildNamedResult(result);
    } else {
      return buildNamedMultiResult();
    }
  }
}
