import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';
import '../state/transaction_store.dart';
import '../utils/qris_saver.dart';
import 'qris_scanner_screen.dart';
import 'payment_loading_screen.dart';

class QrisConfirmScreen extends StatefulWidget {
  final QrisData data;
  final String rawValue;
  const QrisConfirmScreen({super.key, required this.data, required this.rawValue});

  @override
  State<QrisConfirmScreen> createState() => _QrisConfirmScreenState();
}

class _QrisConfirmScreenState extends State<QrisConfirmScreen> {
  late double _amount;
  late TextEditingController _amountCtrl;

  @override
  void initState() {
    super.initState();
    _amount = widget.data.amount;
    _amountCtrl = TextEditingController(text: _amount > 0 ? _amount.toInt().toString() : '');
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  String get _amountFormatted {
    if (_amount <= 0) return 'Rp 0';
    final intVal = _amount.toInt();
    final s = intVal.toString();
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write('.');
      result.write(s[i]);
    }
    return 'Rp ${result.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left, color: kTextDark, size: 28),
        ),
        title: const Text(
          'Konfirmasi',
          style: TextStyle(color: kTextDark, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildParties(),
                  const SizedBox(height: 12),
                  _buildAmountSection(),
                ],
              ),
            ),
          ),
          _buildLanjutkanButton(context),
        ],
      ),
    );
  }

  Widget _buildParties() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset('assets/Profile.png', width: 36, height: 36, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Anla Harpanda', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: kTextDark)),
                    Row(
                      children: [
                        Container(
                          width: 13,
                          height: 13,
                          decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                          child: const Center(
                            child: Text('S', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('SeaBank: 901414690015', style: TextStyle(color: kTextGray, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            child: Icon(Icons.arrow_downward, color: kTextGray, size: 18),
          ),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                child: const Icon(Icons.storefront, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.merchantName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: kTextDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.data.city.isNotEmpty)
                      Text(widget.data.city, style: const TextStyle(color: kTextGray, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider),
      ),
      child: Column(
        children: [
          if (!widget.data.hasAmount) ...[
            Row(
              children: [
                const Expanded(child: Text('Jumlah', style: TextStyle(color: kTextGray, fontSize: 13))),
                SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _amountCtrl,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      hintText: '0',
                      prefixText: 'Rp ',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kTextDark),
                    onChanged: (v) => setState(() => _amount = double.tryParse(v) ?? 0),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: kDivider),
          ],
          _buildRow('Total', _amountFormatted, bold: true),
          const SizedBox(height: 8),
          _buildRow('Nominal Transaksi', _amountFormatted),
          const SizedBox(height: 8),
          _buildRow('Biaya Transaksi', 'GRATIS', green: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool bold = false, bool green = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: kTextGray, fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w400,
            color: green ? kOrange : kTextDark,
          ),
        ),
      ],
    );
  }

  Widget _buildLanjutkanButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showPinSheet(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: kOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Lanjutkan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  void _showPinSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PinSheet(
        amount: _amountFormatted,
        merchantName: widget.data.merchantName,
        merchantCity: widget.data.city,
        onSuccess: () {
          final tx = _buildTransaction();
          addTransaction(tx);
          saveQrisToGallery(widget.rawValue, widget.data.merchantName).then((saved) {
            if (saved && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QRIS tersimpan ke galeri'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          });
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => PaymentLoadingScreen(transaction: tx)),
            (route) => route.isFirst,
          );
        },
      ),
    );
  }

  TransactionItem _buildTransaction() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
    final dateStr = '${now.day} ${months[now.month - 1]} ${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final rand = Random();
    final txNum = '2026${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${List.generate(16, (_) => rand.nextInt(10)).join()}';
    final refNum = '010000${List.generate(6, (_) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'[rand.nextInt(36)]).join()}';
    final termId = List.generate(16, (_) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'[rand.nextInt(62)]).join();
    final acquirerNames = ['GoPay', 'OVO', 'DANA', 'LinkAja'];
    final acquirerName = acquirerNames[rand.nextInt(acquirerNames.length)];
    final acqAccount = '${9000 + rand.nextInt(999)}-${rand.nextInt(9999).toString().padLeft(4, '0')}-${rand.nextInt(9999).toString().padLeft(4, '0')}-${rand.nextInt(9999).toString().padLeft(4, '0')}-${rand.nextInt(999).toString().padLeft(3, '0')}';

    String amtRaw = _amount.toInt().toString();
    final buf = StringBuffer();
    for (int i = 0; i < amtRaw.length; i++) {
      if (i > 0 && (amtRaw.length - i) % 3 == 0) buf.write('.');
      buf.write(amtRaw[i]);
    }

    return TransactionItem(
      id: txNum,
      iconType: TxIconType.store,
      name: widget.data.merchantName,
      category: 'Pembayaran',
      date: dateStr,
      amount: '-$_amountFormatted',
      isPositive: false,
      amountValue: buf.toString(),
      toName: widget.data.merchantName,
      toLocation: widget.data.city,
      acquirer: acquirerName,
      acquirerAccount: acqAccount,
      txNumber: txNum,
      refNumber: refNum,
      terminalId: termId,
    );
  }
}

class _PinSheet extends StatefulWidget {
  final String amount;
  final String merchantName;
  final String merchantCity;
  final VoidCallback onSuccess;
  const _PinSheet({
    required this.amount,
    required this.merchantName,
    required this.merchantCity,
    required this.onSuccess,
  });

  @override
  State<_PinSheet> createState() => _PinSheetState();
}

class _PinSheetState extends State<_PinSheet> {
  static const _correctPin = '728171';
  String _pin = '';
  bool _error = false;

  void _addDigit(String d) {
    if (_pin.length >= 6) return;
    setState(() {
      _pin += d;
      _error = false;
    });
    if (_pin.length == 6) _verify();
  }

  void _backspace() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = false;
    });
  }

  void _verify() {
    if (_pin == _correctPin) {
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      setState(() {
        _error = true;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),
          const Text(
            'PIN SeaBank Kamu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextDark),
          ),
          const SizedBox(height: 6),
          Text(
            _error
                ? 'PIN salah. Coba lagi.'
                : 'Demi alasan keamanan, mohon masukkan PIN Anda',
            style: TextStyle(fontSize: 12, color: _error ? Colors.red : kTextGray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {},
            child: const Text('Lupa PIN?', style: TextStyle(color: kBlue, fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < _pin.length ? kTextDark : Colors.transparent,
                border: Border.all(color: _error ? Colors.red : const Color(0xFFBDBDBD), width: 1.5),
              ),
            )),
          ),
          const SizedBox(height: 24),
          _buildKeypad(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: keys.map((row) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.map((key) => Expanded(
              child: key.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () => key == '⌫' ? _backspace() : _addDigit(key),
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: key == '⌫'
                                ? const Icon(Icons.backspace_outlined, size: 22, color: kTextDark)
                                : Text(
                                    key,
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kTextDark),
                                  ),
                          ),
                        ),
                      ),
                    ),
            )).toList(),
          ),
        )).toList(),
      ),
    );
  }
}
