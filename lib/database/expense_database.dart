import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseDatabase extends ChangeNotifier{
  static late Isar isar;
  List<Expense> _allExpenses = [];

  /* setup */

  static Future<void> initialize() async{
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema], directory: dir.path);
  }
  List<Expense> get getExpense =>  _allExpenses;

  Future<void> createNewExpense(Expense newExpense) async{
    await isar.writeTxn(() => isar.expenses.put(newExpense));
    readExpenses();
  }

  Future<void> readExpenses() async {
    List<Expense> fetchedExpenses  = await isar.expenses.where().findAll();
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);
    // update ui
    notifyListeners();
  }

  Future<void> updateExpense(int id, Expense updatedExpense) async {
    // make sure new expense has same id existing one
    updatedExpense.id = id;

    await isar.writeTxn(() => isar.expenses.put(updatedExpense));
    await readExpenses();
  }

  Future<void> deleteExpense(int id) async{
    await isar.writeTxn(() => isar.expenses.delete(id));
    await readExpenses();
  }

}