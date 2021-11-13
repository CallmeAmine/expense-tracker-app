import 'package:expense_tracker/src/model/transaction_modal.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Transaction> getTransaction() => Hive.box<Transaction>('transactions');

}