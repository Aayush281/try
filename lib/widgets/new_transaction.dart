import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './adaptive_flatbutton.dart';
// This widget holds our text fields

//We had to convert this widget into a stateful widget because in a stateless widget when flutter re-evaluates the widget , the previously
//stored data is lost (ie when we enetered title then went to store amount , we lost the title.)

//In stateful widget , we have the seperation of the UI and state , hence we can persist data

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx) {
    print('Constructor NewTransaction Widget');
  }

  @override
  State<NewTransaction> createState() {
    print('createState transaction widget');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate;

  //Do not need this constructor but we are adding it for educational purposes
  _NewTransactionState() {
    print('Constructor NewTransaction state');
  }

  //only code executed by initState() in the parent class checks whether "everything is working as intended". It's a debugging-only check, 
  //which will have no impact in production mode.
  @override
  void initState() {
    print('initState()');
    super.initState();
  }

  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print('dispose()');
    super.dispose();
  }

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredAmount < 0 ||
        enteredAmount == 0 ||
        enteredTitle.isEmpty ||
        selectedDate == null) {
      return;
    }
    //Gives you access to the state classes (ie here addTx is defined in the upper class and widget lets you access the upper class )
    widget.addTx(
      enteredTitle,
      enteredAmount,
      selectedDate,
    );

    //Here , the modal sheet automatically closes after an item is entered due to the bottom command
    //The context word here gives you access to the context of your widget
    Navigator.of(context).pop();
  }

  //Below the 'then' part is added to store the date the user picks.
  void _datePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2018),
            lastDate: DateTime.now())
        .then((datePicked) {
      if (datePicked == null) {
        return;
      }
      setState(() {
        selectedDate = datePicked;
      });
    });
  }

  // We are passing the function pointer addTx only right now so that it gets executed at the appropriate time
  @override
  Widget build(BuildContext context) {
    print('build() of new_transaction');
    //we have used singlechildscrollview because in case the device is small then we want to scroll the modal sheet
    return SingleChildScrollView(
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) {
                  submitData();
                },
                // underscore is a uselss argument we have to pass otherwise flutter will complain
                // onChanged: (val) {
                //   titleinput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  submitData();
                },
                // onChanged: (val) {
                //   amountInput = val;
                // },
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    //Exapanded widget is here because we want the text to take maximum space as possible(giving button only space it needs)
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'No date chosen!'
                            : 'Picked date : ${DateFormat.yMd().format(selectedDate)}',
                      ),
                    ),
                    AdaptiveButton(_datePicker),
                  ],
                ),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'Add transaction',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//controllers listen to the user input and save the user input

//Without paranthesis we just pass the pointer to the function and with paranthesis we instatiate the function then and there

// double.parse() is like typecasting because the constructor in user_transactions has arguments string and double respectively
