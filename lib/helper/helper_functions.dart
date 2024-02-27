
import 'package:intl/intl.dart';

double convertStrintToDouble(String string){
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

String formatAmount(double amount){
    final format = NumberFormat.currency(locale: 'tr_TR', symbol: '\₺', decimalDigits: 2);
    return format.format(amount);
}

int calculateMonthCount(int startYear, startMonth, currentYear, currentMonth){
  return (currentYear-startYear)  *12 + currentMonth-startMonth + 1;
}

String getCurrentMonthName(){
  DateTime now = DateTime.now();
  List<String> l = [
      "OCK",
      "ŞBT",
      "MRT",
      "NSN",
      "MYS",
      "HZR",
      "TMZ",
      "AUG",
      "EYL",
      "EKM",
      "KSM",
      "ARL"
  ];
  return l[now.month - 1];
}