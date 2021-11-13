import 'package:expense_tracker/src/model/transaction_modal.dart';
import 'package:expense_tracker/src/theme.dart';
import 'package:expense_tracker/src/view/expense_tracker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {

  WidgetsFlutterBinding.ensureInitialized();    

  // initialize hive in flutter
  await Hive.initFlutter();
  
  // register modal adapter
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  
  runApp(const MyExpenseTrackerApp());

}
class MyExpenseTrackerApp extends StatelessWidget {
  const MyExpenseTrackerApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: "Expense Tracker",
        theme: expenseTrackerTheme(),
        home: const ExpenseTracker(),
    );
  }
}
