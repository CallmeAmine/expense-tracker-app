import 'package:expense_tracker/src/model/transaction_modal.dart';
import 'package:flutter/material.dart';

class TransactionDialog extends StatefulWidget {
  final Transaction? transaction;
  final Function(String name, double amount, bool isExpense) onClickDone;
  const TransactionDialog(
      {Key? key, this.transaction, required this.onClickDone})
      : super(key: key);
  static const String routeName = '/transactionDialog';
  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool isExpense = true;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final transaction = widget.transaction;
      _nameController.text = transaction!.name;
      _amountController.text = transaction.amount.toString();
      isExpense = transaction.isExpense;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Transaction' : "Add Transaction";
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              buildName(),
              const SizedBox(
                height: 10.0,
              ),
              buildAmount(),
              const SizedBox(
                height: 10.0,
              ),
              buildRadioButtons()
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing)
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: 'Enter Name'),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );
  Widget buildAmount() => TextFormField(
        controller: _amountController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: 'Enter amount'),
        validator: (amount) => amount != null && double.tryParse(amount) == null
            ? 'Enter a valid number'
            : null,
      );
  Widget buildRadioButtons() => Column(
        children: [
          RadioListTile<bool>(
            title: const Text('Expense'),
            value: true,
            groupValue: isExpense,
            onChanged: (value) => setState(() => isExpense = value!),
          ),
          RadioListTile<bool>(
            title: const Text('Income'),
            value: false,
            groupValue: isExpense,
            onChanged: (value) => setState(() => isExpense = value!),
          ),
        ],
      );
  Widget buildCancelButton(BuildContext context) => TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      );
  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text  = isEditing ? 'Save' : 'Add';
    return TextButton(
      child: Text(text), 
      onPressed: ()async{
        final isValid = formKey.currentState!.validate();
      if(isValid){
        final name = _nameController.text;
        final amount = double.tryParse(_amountController.text) ?? 0;

        widget.onClickDone(name, amount, isExpense);

        Navigator.pop(context);
      }
      }, 
      );
  }
}
