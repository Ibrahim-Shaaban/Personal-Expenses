import 'dart:io';

import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/chart.dart';
// import './widgets/user_transactions.dart';
import './models/transaction.dart';
import './widgets/transactions_list.dart';
import './widgets/add_transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
              title: TextStyle(
                fontFamily: "Quicksand",
                // fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          fontFamily: "OpenSans"),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  double _getDeviceHeight({
    @required BuildContext context,
    @required PreferredSizeWidget appBar,
  }) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;

    return height;
  }

  List<Transaction> _transactions = [];

  void addTransaction(
      {@required String title,
      @required double amount,
      @required DateTime transactionDate}) {
    Transaction newTransction = Transaction(
      title: title,
      amount: amount,
      id: DateTime.now().toString(),
      date: transactionDate,
    );
    setState(() {
      _transactions.add(newTransction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) {
        return transaction.id == id;
      });
    });
  }

  void startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: AddTransaction(
              addTransaction: addTransaction,
            ),
          );
        });
  }

  Widget appBar(
      {@required BuildContext context,
      @required Function startNewTransaction}) {
    return AppBar(
      title: Text("Personal Expenses"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            startNewTransaction(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _chartWidget(heightRatio) {
      return Container(
        height: _getDeviceHeight(
                context: context,
                appBar: appBar(
                    context: context,
                    startNewTransaction: startNewTransaction)) *
            heightRatio,
        width: double.infinity,
        child: Chart(recentTransactions: _recentTransactions),
      );
    }

    Widget _transactionsListwidget(heightRatio) {
      return Container(
        height: _getDeviceHeight(
                context: context,
                appBar: appBar(
                    context: context,
                    startNewTransaction: startNewTransaction)) *
            heightRatio,
        child: TransactionsList(
          transactions: _transactions,
          deleteTransaction: _deleteTransaction,
        ),
      );
    }

    Widget _switchWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "show chart",
          style: TextStyle(fontSize: 17),
        ),
        Switch.adaptive(
          value: _showChart,
          onChanged: (val) {
            setState(() {
              _showChart = val;
            });
          },
        )
      ],
    );

    List<Widget> _handleView() {
      var isLandscape =
          MediaQuery.of(context).orientation == Orientation.landscape;
      if (isLandscape) {
        return [
          _switchWidget,
          _showChart ? _chartWidget(.6) : _transactionsListwidget(.7)
        ];
      }
      return [
        _chartWidget(.3),
        _transactionsListwidget(.7),
      ];
    }

    return Scaffold(
      appBar:
          appBar(context: context, startNewTransaction: startNewTransaction),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // _switchWidget,
            // _showChart ? _transactionsListwidget(.7) : _chartWidget(.6),
            ..._handleView()
          ],
        ),
      ),
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                startNewTransaction(context);
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
