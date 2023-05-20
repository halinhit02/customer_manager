import 'package:intl/intl.dart';

class NumberUtils {
  static String formatMoney(int money) {
    var format = NumberFormat.currency(locale: "vi-vi", symbol: "VND",);
    return format.format(money);
  }
}