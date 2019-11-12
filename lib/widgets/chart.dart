import 'package:flutter/material.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart({@required this.recentTransactions});

  List<Map<String, Object>> get chartBars {
    return List.generate(7, (index) {
      var currentDate = DateTime.now().subtract(Duration(days: index));
      var weekDay = DateFormat.E().format(currentDate).substring(0, 1);
      double totalAMount = 0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == currentDate.day &&
            recentTransactions[i].date.month == currentDate.month &&
            recentTransactions[i].date.year == currentDate.year) {
          totalAMount += recentTransactions[i].amount;
        }
      }
      return {"day": weekDay, "amount": totalAMount};
    }).reversed.toList();
  }

  double get allAmountOfWeek {
    return chartBars.fold(0, (sum, chartBar) {
      return sum + chartBar['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(chartBars);
    return Card(
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: chartBars.map((chartBar) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  totalAmount: chartBar['amount'],
                  weekDay: chartBar['day'],
                  amountPercentage: allAmountOfWeek == 0
                      ? 0
                      : (chartBar['amount'] as double) / allAmountOfWeek),
            );
          }).toList(),
        ));
  }
}
