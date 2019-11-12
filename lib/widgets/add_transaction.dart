import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function addTransaction;

  AddTransaction({@required this.addTransaction});

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _titleInputController = TextEditingController();
  final _amountInputController = TextEditingController();
  DateTime _transactionDate;

  void _chooseDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _transactionDate = pickedDate;
      });
    });
  }

  void _onSubmitData() {
    String title = _titleInputController.text;
    double amount = double.parse(_amountInputController.text);

    bool isDataValidated = canAddTransaction(title, amount, _transactionDate);
    if (isDataValidated) {
      widget.addTransaction(
          title: title, amount: amount, transactionDate: _transactionDate);
      Navigator.of(context).pop();
    } else
      return;
  }

  bool canAddTransaction(String title, double amount, DateTime pickedDate) {
    if (title.isEmpty || amount <= 0 || pickedDate == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "title"),
                controller: _titleInputController,
                onSubmitted: (_) {
                  _onSubmitData();
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: "amount"),
                controller: _amountInputController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) {
                  _onSubmitData();
                },
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_transactionDate != null
                          ? DateFormat.yMd().format(_transactionDate)
                          : "No date chosen "),
                    ),
                    FlatButton(
                      child: Text(
                        "choose date",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      onPressed: _chooseDate,
                    )
                  ],
                ),
              ),
              RaisedButton(
                  child: Text(
                    "add transaction",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: _onSubmitData)
            ],
          ),
        ));
  }
}
