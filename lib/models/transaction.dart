import 'package:flutter/material.dart';

class Transaction {
  String id;
  String title;
  double amount;
  DateTime dateTime;

  Transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.dateTime});
}

//Remember the syntax for passing multiple arguments it is Transaction({}) otherwise error

//@required is to tell the compiler that all the properties are required definitely and none are by mistake