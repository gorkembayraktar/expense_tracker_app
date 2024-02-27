import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/components/my_list_tile.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/helper/helper_functions.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Future<Map<int, double>>? _montlyTotalsFuture;
  Future<double>? _calculateCurrentMonthTotal;

  @override
  void initState() {
    Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();

    refreshData();

    super.initState();
  }

  void refreshData(){
    _montlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false).calculateMonthlyTotals();
    _calculateCurrentMonthTotal = Provider.of<ExpenseDatabase>(context, listen: false).calculateCurrentMonthTotal();
  }

  void openNewExpenseBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('New Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  TextField(
                    controller: amountController,
                    decoration: const InputDecoration(hintText: "Amount"),
                  )
                ],
              ),
              actions: [_cancelButton(), _createNewExpenseButton()],
            ));
  }

  void openEditBox(Expense expense){

    // önceki datayı doldur
    String name = expense.name;
    String amount = expense.amount.toString();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Edit Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration:  InputDecoration(hintText: name),
              ),
              TextField(
                controller: amountController,
                decoration:  InputDecoration(hintText: amount),
              )
            ],
          ),
          actions: [_cancelButton(), _editExpenseButton(expense)],
        ));
  }

  void openDeleteBox(Expense expense){
// önceki datayı doldur
    String name = expense.name;
    String amount = expense.amount.toString();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Delete Expense ? '),
          actions: [_cancelButton(), _deleteExpenseButton(expense.id)],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
        builder: (context, value, child){

          int startMonth = value.getStartMonth();
          int startYear = value.getStartYear();
          int currentMonth = DateTime.now().month;
          int currentYear = DateTime.now().year;

          int monthCount = calculateMonthCount(startYear, startMonth, currentYear, currentMonth);

          List<Expense> currentMonthExpenses = value.getExpense.where((expense){
            return expense.date.year == currentYear && expense.date.month == currentMonth;
          }).toList();

          return Scaffold(
              backgroundColor: Colors.grey.shade300,
              floatingActionButton: FloatingActionButton(
                onPressed: openNewExpenseBox,
                child: const Icon(Icons.add),
              ),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: FutureBuilder<double>(
                  future: _calculateCurrentMonthTotal,
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${snapshot.data!.toStringAsFixed(2)} ₺'),
                          Text(getCurrentMonthName())
                        ],
                      );
                    }
                    return const Text('loading..');
                  },
                ),
              ),
              body: Column(
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: 250,
                      child: FutureBuilder(
                          future: _montlyTotalsFuture,
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              final monthlyTotals = snapshot.data ?? {};
                              List<double> monthlySummary = List.generate(monthCount, (index) => monthlyTotals[startMonth + index] ?? 0.0);
                    
                              return MyBarGraph(monthlySummary: monthlySummary, startMonth: startMonth);
                            }
                    
                            return const Center(child: Text('Loading..'),);
                          }
                      ),
                    ),
                  )
                  ,
                  Expanded(
                      child: ListView.builder(
                        itemCount: currentMonthExpenses.length,
                        itemBuilder: (context, index){

                          int reversedIndex = currentMonthExpenses.length - index - 1;

                          Expense individaulExpense = currentMonthExpenses[reversedIndex];

                          return MyListTile(
                            title: individaulExpense.name,
                            trailing: formatAmount(individaulExpense.amount),
                            onEditPressed: (context) => openEditBox(individaulExpense),
                            onDeletePressed: (context) => openDeleteBox(individaulExpense),
                          );
                        },
                      )
                  )
                ],
              )
          );
        }
    );
  }

  Widget _cancelButton() {
    return MaterialButton(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
          nameController.clear();
          amountController.clear();
        });
  }

  Widget _createNewExpenseButton() {
    return MaterialButton(
        child: const Text('Save'),
        onPressed: () async {
          if (nameController.text.isNotEmpty &&
              amountController.text.isNotEmpty) {
            Navigator.pop(context);
            Expense expense = Expense(
                name: nameController.text,
                amount: convertStrintToDouble(amountController.text),
                date: DateTime.now());

            await context.read<ExpenseDatabase>().createNewExpense(expense);

            // refresh graph data
            refreshData();

            nameController.clear();
            amountController.clear();
          }
        });
  }

  Widget _editExpenseButton(Expense expense) {
    return MaterialButton(
        child: const Text('Update'),
        onPressed: () async {
            Navigator.pop(context);
            Expense updatedExpense = Expense(
                name: nameController.text.isNotEmpty
                    ? nameController.text
                    : expense.name,
                amount:
                    amountController.text.isNotEmpty ?
                    convertStrintToDouble(amountController.text)
                    : expense.amount,
                date: DateTime.now());

            int existsId = expense.id;

            await context.read<ExpenseDatabase>().updateExpense(existsId, updatedExpense);

            // refresh graph data
            refreshData();

            nameController.clear();
            amountController.clear();

        });
  }

  Widget _deleteExpenseButton(int id){
    return MaterialButton(
        child: const Text('Delete'),
        onPressed: () async {
          Navigator.pop(context);
          await context.read<ExpenseDatabase>().deleteExpense(id);

          // refresh graph data
          refreshData();
        }
      );
  }
}
