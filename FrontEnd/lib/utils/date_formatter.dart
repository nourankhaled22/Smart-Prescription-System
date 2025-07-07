import 'package:intl/intl.dart';

String formatDate(String isoDate) {
  try {
    final date = DateTime.parse(isoDate);
    return DateFormat('dd/MM/yyyy').format(date); // e.g., 18/01/1990
  } catch (e) {
    return isoDate;
  }
}
