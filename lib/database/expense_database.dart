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

  Future<Map<int, double>> calculateMonthlyTotals() async{
    await readExpenses();
    Map<int, double> monthlyTotals = {};
    for(var expense in _allExpenses){
        int month = expense.date.month;
        if(!monthlyTotals.containsKey(month)){
          monthlyTotals[month] = 0;
        }

        monthlyTotals[month] = monthlyTotals[month]! + expense.amount;
    }

    return monthlyTotals;
  }

  Future<double> calculateCurrentMonthTotal() async{
    await readExpenses();
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;
    List<Expense> currentMonthExpenses = _allExpenses.where((expense){
      return expense.date.year == currentYear && expense.date.month == currentMonth;
    }).toList();
    double total = currentMonthExpenses.fold(0, (sum, expense)=>sum+expense.amount);
    return total;
  }

  int getStartMonth(){
    if(_allExpenses.isEmpty){
      return DateTime.now().month;
    }
    _allExpenses.sort(
        (a,b) => a.date.compareTo(b.date)
    );

    return _allExpenses.first.date.month;
  }

  int getStartYear(){
    if(_allExpenses.isEmpty){
      return DateTime.now().year;
    }
    _allExpenses.sort(
            (a,b) => a.date.compareTo(b.date)
    );

    return _allExpenses.first.date.year;
  }
}