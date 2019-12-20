import 'package:d20_dice_roller/roller/ui/roll_result.dart';
import 'package:flutter/material.dart';

class RollerModalSheet extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final TextStyle rollerModalSheetStyle = TextStyle(fontSize: 22);
  final TextStyle rollerSubStyle = TextStyle(fontSize: 18);
  final bool expandedResult;

  RollerModalSheet(
    this.results,
    this.expandedResult,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: results.map((result) {
          return RollResult(
            result,
            rollerModalSheetStyle,
            subStyle: rollerSubStyle,
            expandedResult: expandedResult,
          );
        }).toList(),
      ),
    );
  }
}
