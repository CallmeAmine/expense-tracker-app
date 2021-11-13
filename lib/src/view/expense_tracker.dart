import 'package:expense_tracker/src/model/boxes.dart';
import 'package:expense_tracker/src/model/transaction_modal.dart';
import 'package:expense_tracker/src/widget/transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({Key? key}) : super(key: key);
  static String routeName = '/transactionTracker';

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Transaction>>(
          valueListenable: Boxes.getTransaction().listenable(),
          builder: (context, box, _) {
            final transactions = box.values.toList().cast<Transaction>();
            return buildContent(transactions);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
          showDialog(
              context: context,
              builder: (context) =>
                  TransactionDialog(onClickDone: addTransaction));
        }));
  }

  Widget buildContent(List<Transaction> transactions) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No Expenses yet',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      final netExpense = transactions.fold<double>(
          0,
          (previousValue, transaction) => transaction.isExpense
              ? previousValue - transaction.amount
              : previousValue + transaction.amount);
      final newExpenseString = 'Rs. ${netExpense.toStringAsFixed(2)}';
      final color = netExpense > 0 ? Colors.green : Colors.red;

      return Column(
        children: [
          const SizedBox(
            height: 24.0,
          ),
          Text(
            'Net Expense $newExpenseString',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: color),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: transactions.length,
                  itemBuilder: (BuildContext context, int index) {
                    final transaction = transactions[index];
                    return buildTransaction(context, transaction);
                  }))
        ],
      );
    }
  }

  Widget buildTransaction(BuildContext context, Transaction transaction) {
    final color = transaction.isExpense ? Colors.red : Colors.green;
    final date = DateFormat.yMMMd().format(transaction.createdAt);
    final amount = 'Rs. ' + transaction.amount.toStringAsFixed(2);

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          transaction.name,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [buildButtons(context, transaction)],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Transaction transaction) => Row(
        children: [
          Expanded(
              child: TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TransactionDialog(
                      transaction: transaction,
                      onClickDone: (name, amount, isExpense ) => 
                      editTransaction(transaction, name, amount, isExpense)))), 
                  icon: const Icon(Icons.edit), 
                  label: const Text('Edit'), 
          ),
        ),
          Expanded(
            child: TextButton.icon(
              label: const Text('Delete'),
              icon: const Icon(Icons.delete), 
              onPressed: ()=> deleteTransaction(transaction), 
              
              ))
        ],
      );

  Future addTransaction(String name, double amount, bool isExpense) async {
    final transaction = Transaction()
      ..name = name
      ..createdAt = DateTime.now()
      ..amount = amount
      ..isExpense = isExpense;

    final box = Boxes.getTransaction();
    box.add(transaction);
  }
  void editTransaction(
    Transaction transaction, 
    String name, 
    double amount, 
    bool isExpense 
    ){
      transaction.name = name;
      transaction.amount = amount;
      transaction.isExpense = isExpense;

      transaction.save();
  }
  void deleteTransaction(Transaction transaction) {
    transaction.delete();
  }
}
