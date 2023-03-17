import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    print('build() of chartbar');
    return LayoutBuilder(
      //We have the constraints object available below as an argument and can use that to dynamically calculate height
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            //toStringAsFixed(0) means that no decimal places
            //FittedBox widget is used to shrink the text in case something long is put by user
            Container(
              height: constraints.maxHeight * 0.1,
              child: FittedBox(
                child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.7,
              width: 10,
              //Stack widget allows to to overlap different stuff on each other
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      //Container color we are assigning below ie it is the background color
                      color: Color.fromRGBO(220, 220, 220, 1),
                      //Below property is for rounded corners
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  //
                  FractionallySizedBox(
                    heightFactor: spendingPctOfTotal,
                    //The below container will have the desired background color
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            Container(
              height: constraints.maxHeight * 0.1,
              //Below have wrapped into fitted box incase the device is very small and we have to adjust the text accordingly
              child: FittedBox(
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}
