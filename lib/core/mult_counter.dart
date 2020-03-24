import 'package:d20_dice_roller/core/mult_button.dart';
import 'package:flutter/material.dart';

class MultCounter extends StatelessWidget {
  final bool checkBoxValue;
  final bool forRoller;
  final String counterState;
  final BuildContext context;
  final Function handleCheckboxChanged;
  final bool showCheckBox;
  final Function handleIncrement;
  final Function handleDecrement;
  final bool scaffoldBackground;

  MultCounter(
    this.counterState,
    this.context, {
    this.handleCheckboxChanged,
    this.checkBoxValue = false,
    this.showCheckBox = true,
    this.handleIncrement,
    this.handleDecrement,
    this.forRoller = false,
    this.scaffoldBackground = false,
    Key key,
  })  : assert(handleCheckboxChanged != null || !showCheckBox),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (forRoller) {
      return Container(
        height: 66,
        child: Center(
          child: Checkbox(
            value: checkBoxValue,
            onChanged: handleCheckboxChanged,
          ),
        ),
      );
    }
    if (showCheckBox && !checkBoxValue) {
      return Container(
        height: 66,
        child: Center(
          child: Checkbox(
            value: checkBoxValue,
            onChanged: handleCheckboxChanged,
          ),
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide()),
                  color: scaffoldBackground
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).backgroundColor),
              child: Text(counterState),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: MultButton(
                    text: '+',
                    onTap: handleIncrement,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Flexible(
                  flex: 2,
                  child: MultButton(
                    text: '-',
                    onTap: int.tryParse(counterState) > 1
                        ? () {
                            handleDecrement();
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
