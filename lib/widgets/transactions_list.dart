import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  TransactionsList(
      {@required this.transactions, @required this.deleteTransaction});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: transactions.isEmpty
              ? Column(
                  children: <Widget>[
                    Text(
                      "No transactions found...",
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: constraints.maxHeight * .6,
                      // width: constraints.maxWidth * .3,
                      child: Image.asset(
                        "assets/images/waiting.png",
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                )
              : ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: FittedBox(
                              child: Text('\$${transactions[index].amount}'),
                            ),
                          ),
                        ),
                        title: Text(
                          transactions[index].title,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "OpenSans"),
                        ),
                        subtitle: Text(
                          DateFormat.yMMMd().format(transactions[index].date),
                        ),
                        trailing: MediaQuery.of(context).size.width >= 400
                            ? FlatButton.icon(
                                label: Text("Delete"),
                                icon: Icon(Icons.delete),
                                textColor: Theme.of(context).errorColor,
                                onPressed: () {
                                  deleteTransaction(transactions[index].id);
                                },
                              )
                            : IconButton(
                                iconSize: 30,
                                color: Theme.of(context).errorColor,
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteTransaction(transactions[index].id);
                                },
                              ),
                      ),
                    );
                  },
                  itemCount: transactions.length,
                ),
        );
      },
    );
  }
}
