import 'package:flutter/material.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

//The widget which will be handling states will be a stateless widget

//Do not create the main widget into stateful because it is a long widget and also makes performance slower.

//The parts that interact with transaction list - we will make them into new widgets

// We should not manage our states over here since this is a stateless widget - to do this , we create user_transactions.dart

//Press ctrl and . togesther to convert stateless widget into a stateful one

void main() {
  // The below code is to force the app to only work in portrait orientation
  //First line is required because without it the code wont work on some phones
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  // );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Now here if you change the primarySwatch color then the colors for all the widgets will be changed so we don't have to do manually
        primarySwatch: Colors.purple,
        //another color option if you want to mix colors
        accentColor: Colors.amber,
        errorColor: Colors.red,
        // fontFamily: 'Quicksand',
      ),
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State <MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   dateTime: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   dateTime: DateTime.now(),
    // ),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void didChangeAppLifeCycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    //where() allows to run a function on every item in the list and if the function returns true then the item is kept in a newly created
    //list otherwise it is not included in the newly created list
    print(_userTransactions);

    return _userTransactions.where((tx) {
      print(tx);
      //dateTime is a DateTime class object...here isAfter will check whether the date is before today minus 7 days
      return tx.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      dateTime: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          //ie if you tap on the modal sheet , nothing happens
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  //just like add is a function which can be operated in list , delete is a similar function
  void _deleteTransaction(String id) {
    setState(() {
      //anonymous function passed below gets the element of each list
      _userTransactions.removeWhere((tx) {
        //if we return true the transaction will be deleted and it will return true if below condition is satisfied
        return tx.id == id;
      });
    });
  }

  //Here it will return a widget hence it is of type widget
  //This is called a builder method
  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Display chart'),
          Switch(
            //depending upon the vale , we will switch the button
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            },
          )
        ],
      ),
      _showChart
          ? Container(
              //here we are taking 30 % of the total height minus appbar height minus statusbar height
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.3,
              child: Chart(_recentTransactions),
            )
          : txListWidget,
    ];
  }

  //We are returning a list of widgets here hence the return type is List<Widget>
  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        //here we are taking 30 % of the total height minus appbar height minus statusbar height
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  PreferredSizeWidget _buildAppBarContent() {
    return AppBar(
      title: Text('Flutter App'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
  }

  bool _showChart = true;

  @override
  Widget build(BuildContext context) {
    print('build() of main');
    //if you are using the mediaquery widget a lot then you can also create a variable to store that for instance:
    final mediaQuery = MediaQuery.of(context);
    //Below variable is recalculated for every build run
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    //Now you can access the appbar object anywhere since it is stored in a variable , has info on the height of the appbar.
    //Thats why we have stored it in a variable
    final appBar = _buildAppBarContent();
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    return Scaffold(
      appBar: _buildAppBarContent(),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //ie if isLandscape is true , then following will be executed else not.
            if (isLandscape)
              ..._buildLandscapeContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
            //Here we need to add ... as a list of widgets is not accepted by flutter and by adding this we flatten the list
            //Hence instead of it being a list of list it will then just be a list of widgets
            if (!isLandscape)
              ..._buildPortraitContent(
                mediaQuery,
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}

//ListView() is a widget which is same as Column() and ListChildScrollView() combined

//Have imported intl package to display date time format in readable format

//First $ sign is treated as a normal character in string because of /
// Second $ sign is treated as a string interpolation

//child: Text(tx.amount.toString()) toString() is added as Text expects a string (because it is text)

// Each transaction is a Card . Since the number of transactions(Cards) cannot be hardcoded, we have to take our transaction list and map
// them into a list of widgets BECAUSE the transactions will be dynamic (ie we dont know how many transactions will be there)
// Let the name of a single transaction be tx

//by using map() we convert the list of objects into a list of widgets

//Since we have used Column() they are below each other.

//In the uppen Card() we have put Card() in container to provide card with different styling options. Haven't done that with lower Card()

// MainAxisAlignment.center This will center the children of column wodgets in the center vertically
//CrossAxisAlignment.end will place the widget at the end of the row it is in currently

// We have created folders inside the main folder to determine which files are widgets and which files are class blueprints
// One widget folder is for the text input throught the text fields

//WE DO NOT NEED THE USER TRANSACTION FILE SO WE DELETED IT.
