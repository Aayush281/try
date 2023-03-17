import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//  Actually this seperate widget has been made to decide whether to use a textButton or a CupertinoButton , but we cannot develop for
//  iOS with windows platform sooo  :)

class AdaptiveButton extends StatelessWidget {
  final Function datePicker;
  AdaptiveButton(this.datePicker);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: datePicker,
        child: Text('Choose date'),
        style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor),
      ),
    );
  }
}
