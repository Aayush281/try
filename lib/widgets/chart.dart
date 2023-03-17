import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import './chartbar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  //below is a getter... a getter is a dynamically calculated property
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        //If error comes it might be from here.
        if (recentTransactions[i].dateTime.day == weekDay.day &&
            recentTransactions[i].dateTime.month == weekDay.month &&
            recentTransactions[i].dateTime.year == weekDay.year) {
          totalSum = totalSum + recentTransactions[i].amount;
        }
      }
      //Substring means only the the letters between 0 and 1 of the day will be displayed
      print(DateFormat.E().format(weekDay).substring(0, 1));
      print(totalSum);

      //Dateformat.E() is a special constructor that will give us only the first letter of the weekday
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
      //Below reversed.toList() is done so that the days appear in the correct order
    }).reversed.toList();
  }

  double get totalSpending {
    //fold allows to change a list to another type
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() of chart');
    // print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      //Padding is like a container but you use it only for adding paddinng
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          //Below makes the bars space around each other evenly
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((data) {
            //Flexible widget is used so that if the amount enetered is too large , then the spacong between the chart bars wont be messed up
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  //Below means that if total spending is zero we pass 0 as an argument else we we pass uske below walla as argument
                  //we have to add as double below as the division operator is defined only for doubles and the first operator was a string
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}

//after video 105 , if we restart the app then the app breaks because  the denominator totalSpending is 0
