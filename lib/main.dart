import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        // ignore: deprecated_member_use
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          // ignore: deprecated_member_use
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
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

class _MyHomePageState extends State<MyHomePage> {
  //list of inbuilt transactions

  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 644.99,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 744.53,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't3',
      title: 'lotion',
      amount: 624.99,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 't4',
      title: 'course',
      amount: 234.53,
      date: DateTime.now().subtract(
        Duration(days: 4),
      ),
    ),
    Transaction(
      id: 't5',
      title: 'booked',
      amount: 624.99,
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    Transaction(
      id: 't6',
      title: 'ticket',
      amount: 234.53,
      date: DateTime.now().subtract(
        Duration(days: 6),
      ),
    )
  ];

  //to get rid of transaciton before 7 days
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

//add new transaction using  the data from new_transaction.dart
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime _selectedDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: _selectedDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

//showModalBottomSheet
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

//delete Transaction
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  bool _showChart = false;
  @override
  Widget build(BuildContext context) {
    var _appBar = AppBar(
      title: Text(
        'Expensio',
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Chart"),
            Switch(
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                })
          ],
        ),
      ],
    );
    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _showChart
                ? Container(
                    height: (MediaQuery.of(context).size.height -
                            _appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top) *
                        .3,
                    child:
                        // Container(
                        //   color: Colors.red,
                        // )
                        Chart(_recentTransactions),
                  )
                : Container(),
            Container(
                height: (MediaQuery.of(context).size.height -
                        _appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    .7,
                child: TransactionList(_userTransactions, _deleteTransaction)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
