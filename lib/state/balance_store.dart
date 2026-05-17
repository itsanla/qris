import 'package:flutter/foundation.dart';

final tabunganNotifier = ValueNotifier<int>(674663);
const int depositoBalance = 5181656;

void addDeposit(int amount) => tabunganNotifier.value += amount;

void deductBalance(int amount) {
  tabunganNotifier.value = (tabunganNotifier.value - amount).clamp(0, 999999999);
}

String formatRp(int amount) {
  final s = amount.toString();
  final buf = StringBuffer('Rp ');
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}

String formatRpPlain(int amount) {
  final s = amount.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return buf.toString();
}
