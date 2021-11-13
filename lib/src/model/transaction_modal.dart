import 'package:hive/hive.dart';

part 'transaction_modal.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject{

  @HiveField(0)
  late String name;

  @HiveField(1)
  late DateTime createdAt;

  @HiveField(2)
  late bool isExpense = true;

  @HiveField(3)
  late double amount;
}











