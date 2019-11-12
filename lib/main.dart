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
  List<Transaction> get _recentTransactions {
    return _transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  List<Transaction> _transactions = [];

  void addTransaction(
      {@required String title,
      @required double amount,
      @required DateTime transactionDate}) {
    var newTransction = Transaction(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Expenses"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              startNewTransaction(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Chart(recentTransactions: _recentTransactions),
            ),
            // UserTransactions()

            TransactionsList(
              transactions: _transactions,
              deleteTransaction: _deleteTransaction,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          startNewTransaction(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
