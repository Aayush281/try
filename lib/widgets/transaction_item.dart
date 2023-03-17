import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  //used to hold single transaction hence we are changing from a list to a single transaction
  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  //We will use this variable to randomly assign any color
  Color _bgColor;

  void initState() {
    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple
    ];

  //Class 'Random' is imported from math package
  //Below does not need to be wrapped in setState() as it is called after initState and before build().
  _bgColor = availableColors[Random().nextInt(4)];
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        //leading means the widget which is positioned at the start
        leading: CircleAvatar(
          //Another way by whcih we can bring a circle is by Boxdecoration.circle
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        //Here we cannot add const because the data we output does change dynamically
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.dateTime),
        ),
        //below means that if the available width is more than 500pixels then it will display a textbox delete
        trailing: MediaQuery.of(context).size.width > 500
            ? TextButton.icon(
                style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error),
                //Can add const here as The data we output will never change dynamically ... will reduce the complie time
                label: const Text('Delete'),
                onPressed: () {
                  return widget.deleteTx(widget.transaction.id);
                },
                icon: null,
              )
            : IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                //have to pass an anonymous function here since we want to pass our own argument here
                onPressed: () {
                  return widget.deleteTx(widget.transaction.id);
                },
              ),
      ),
    );
  }
}
