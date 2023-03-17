import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() of transaction_list');
    // return Container(
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                //The below widget is used for creating seperation between the text and the image(empty box occupying 10 pixels )
                SizedBox(
                  height: 10,
                ),
                //This below widget is used to add an image
                //We are wrapping the image in a container to provide correct height so that it does not overflow(ie no yellow marker)
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/shopAppImage.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
          //Here we are accepting key because if the first transaction is dynamicallly assigned blue color then the second one is dynamically assigned purple and then we delete the first transaction , then the second transaction color changes to blue and we dont want that to happen
        : ListView(
            children: transactions.map((tx) {
              return TransactionItem(
                key: ValueKey(tx.id),
                transaction: tx,
                deleteTx: deleteTx,
              );
            }).toList(),
          );
  }
}

//alternative to listTile widget

//                return Card(
//                   child: Row(
//                     children: [
//                       Container(
//                         margin:
//                             EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black, width: 2),
//                         ),
//                         child: Text(
//                           '\$ ${transactions[index].amount.toStringAsFixed(2)}',
//                           //gets rounded off to the nearest 2 digit number
//                           style: TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.bold,
//                               color: Theme.of(context).primaryColorDark),
//                         ),
//                         padding: EdgeInsets.all(10),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             transactions[index].title,
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             DateFormat('dd/mm/yyyy')
//                                 .format(transactions[index].dateTime),
//                             style: TextStyle(
//                                 color: Theme.of(context).primaryColorDark),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
