
import 'package:intl/intl.dart';

double convertStrintToDouble(String string){
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

String formatAmount(double amount){
    final format = NumberFormat.currency(locale: 'tr_TR', symbol: '\₺', decimalDigits: 2);
    return format.format(amount);
}