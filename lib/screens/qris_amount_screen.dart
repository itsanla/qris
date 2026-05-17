import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';
import '../state/balance_store.dart';
import 'qris_scanner_screen.dart';
import 'qris_confirm_screen.dart';

class QrisAmountScreen extends StatefulWidget {
  final QrisData data;
  final String rawValue;

  const QrisAmountScreen({
    super.key,
    required this.data,
    required this.rawValue,
  });

  @override
  State<QrisAmountScreen> createState() => _QrisAmountScreenState();
}

class _QrisAmountScreenState extends State<QrisAmountScreen> {
  String _amountStr = '';
  late final String _acquirerName;
  late final String _acquirerAccount;

  @override
  void initState() {
    super.initState();
    final rand = Random(widget.rawValue.hashCode);
    const acquirers = ['MANDIRI', 'BCA', 'BNI', 'BRI', 'CIMB'];
    _acquirerName = acquirers[rand.nextInt(acquirers.length)];
    _acquirerAccount =
        '${9000 + rand.nextInt(999)}-'
        '${rand.nextInt(9999).toString().padLeft(4, '0')}-'
        '${rand.nextInt(9999).toString().padLeft(4, '0')}-'
        '${rand.nextInt(9999).toString().padLeft(4, '0')}-'
        '${rand.nextInt(999).toString().padLeft(3, '0')}';
  }

  void _addDigit(String digit) {
    setState(() => _amountStr += digit);
  }

  void _addTripleZero() {
    if (_amountStr.isEmpty) return;
    setState(() => _amountStr += '000');
  }

  void _backspace() {
    if (_amountStr.isEmpty) return;
    setState(() => _amountStr = _amountStr.substring(0, _amountStr.length - 1));
  }

  String get _displayAmount {
    if (_amountStr.isEmpty) return '0';
    final num = int.tryParse(_amountStr) ?? 0;
    final s = num.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return result.toString();
  }

  double get _amount => double.tryParse(_amountStr) ?? 0;

  void _onSelesai() {
    if (_amount <= 0) return;
    final updatedData = QrisData(
      merchantName: widget.data.merchantName,
      city: widget.data.city,
      amount: _amount,
      hasAmount: true,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            QrisConfirmScreen(data: updatedData, rawValue: widget.rawValue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left, color: kTextDark, size: 30),
        ),
        title: const Text(
          'Transfer',
          style: TextStyle(
            color: kTextDark,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildMainCard(),
                  const SizedBox(height: 10),
                  _buildAcquirerCard(),
                ],
              ),
            ),
          ),
          _buildKeypad(context),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Merchant info
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: kOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.merchantName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kTextDark,
                      ),
                    ),
                    if (widget.data.city.isNotEmpty)
                      Text(
                        widget.data.city,
                        style: const TextStyle(
                          color: kTextGray,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: kDivider),
          // Amount row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  'Rp',
                  style: TextStyle(
                    fontSize: 16,
                    color: kTextDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _displayAmount,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
                    color: _amountStr.isEmpty
                        ? const Color(0xFFBDBDBD)
                        : kTextDark,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: kDivider),
          // Saldo + Ubah limit
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: tabunganNotifier,
                  builder: (context, val, child) => Text(
                    'Saldo Tersedia: ${formatRp(val)}',
                    style: const TextStyle(color: kTextGray, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Ubah limit',
                    style: TextStyle(
                      color: kBlue,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: kDivider),
          // Biaya Transaksi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Biaya Transaksi',
                  style: TextStyle(color: kTextDark, fontSize: 14),
                ),
                Text('-', style: TextStyle(color: kTextDark, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcquirerCard() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nama Acquirer',
            style: TextStyle(color: kTextDark, fontSize: 14),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _acquirerName,
                style: const TextStyle(
                  color: kTextDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _acquirerAccount,
                style: const TextStyle(color: kTextGray, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad(BuildContext context) {
    const double rowHeight = 74.0;
    const borderColor = Color(0xFFD0D0D0);

    Widget numKey(String label) {
      final isEmpty = label.isEmpty;
      return Expanded(
        child: GestureDetector(
          onTap: isEmpty
              ? null
              : () {
                  if (label == '000') {
                    _addTripleZero();
                  } else {
                    _addDigit(label);
                  }
                },
          child: Container(
            height: rowHeight,
            decoration: BoxDecoration(
              color: isEmpty ? const Color(0xFFE8E8E8) : Colors.white,
              border: Border.all(color: borderColor, width: 0.5),
            ),
            child: isEmpty
                ? null
                : Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: kTextDark,
                      ),
                    ),
                  ),
          ),
        ),
      );
    }

    final colWidth = MediaQuery.of(context).size.width / 4;

    return SafeArea(
      top: false,
      child: Container(
        color: const Color(0xFFE8E8E8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3-column number grid
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [numKey('1'), numKey('2'), numKey('3')]),
                  Row(children: [numKey('4'), numKey('5'), numKey('6')]),
                  Row(children: [numKey('7'), numKey('8'), numKey('9')]),
                  Row(children: [numKey(''), numKey('0'), numKey('000')]),
                ],
              ),
            ),
            // Right column: backspace + selesai
            SizedBox(
              width: colWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Backspace
                  GestureDetector(
                    onTap: _backspace,
                    child: Container(
                      height: rowHeight,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(color: borderColor, width: 0.5),
                          bottom: BorderSide(color: borderColor, width: 0.5),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.backspace_outlined,
                          size: 24,
                          color: kTextDark,
                        ),
                      ),
                    ),
                  ),
                  // Selesai — spans 3 rows
                  GestureDetector(
                    onTap: _onSelesai,
                    child: Container(
                      height: rowHeight * 3,
                      width: double.infinity,
                      color: kOrange,
                      child: const Center(
                        child: Text(
                          'Selesai',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
