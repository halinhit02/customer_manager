import 'package:intl/intl.dart';

class FormatUtils {

  static String formatDate(int timeMillis) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeMillis);
    return DateFormat('hh:mm dd/MM/yyyy').format(dateTime);
  }

  static String formatMoney(int money) {
    var format = NumberFormat.currency(locale: "vi-vi", symbol: "VND",);
    return format.format(money);
  }
}