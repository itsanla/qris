import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../state/balance_store.dart';
import '../state/transaction_store.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _namaPengirimCtrl = TextEditingController();
  final _namaBankCtrl = TextEditingController();
  final _noRekeningCtrl = TextEditingController();
  final _jumlahCtrl = TextEditingController();

  bool get _isValid =>
      _namaPengirimCtrl.text.trim().isNotEmpty &&
      _namaBankCtrl.text.trim().isNotEmpty &&
      _noRekeningCtrl.text.trim().isNotEmpty &&
      _rawAmount > 0;

  int get _rawAmount {
    final raw = _jumlahCtrl.text.replaceAll('.', '');
    return int.tryParse(raw) ?? 0;
  }

  @override
  void dispose() {
    _namaPengirimCtrl.dispose();
    _namaBankCtrl.dispose();
    _noRekeningCtrl.dispose();
    _jumlahCtrl.dispose();
    super.dispose();
  }

  void _onKonfirmasi() {
    if (!_isValid) return;
    final amount = _rawAmount;
    final amountStr = formatRpPlain(amount);
    final sender = _namaPengirimCtrl.text.trim();
    final bank = _namaBankCtrl.text.trim();
    final noRek = _noRekeningCtrl.text.trim();

    addDeposit(amount);

    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
    final dateStr =
        '${now.day} ${months[now.month - 1]} ${now.year}, '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final rand = Random();
    final txNum =
        '2026${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}'
        '${List.generate(16, (_) => rand.nextInt(10)).join()}';
    final refNum =
        '010000${List.generate(6, (_) => 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'[rand.nextInt(36)]).join()}';

    addTransaction(TransactionItem(
      id: txNum,
      iconType: TxIconType.person,
      name: sender,
      category: 'Deposit',
      date: dateStr,
      amount: '+Rp $amountStr',
      isPositive: true,
      amountValue: amountStr,
      toName: 'Anla Harpanda',
      toLocation: 'SeaBank',
      acquirer: bank,
      acquirerAccount: noRek,
      txNumber: txNum,
      refNumber: refNum,
      terminalId: '-',
    ));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF2ECC71),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 14),
            const Text(
              'Deposit Berhasil',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp $amountStr',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kOrange),
            ),
            const SizedBox(height: 4),
            Text(
              'dari $sender',
              style: const TextStyle(color: kTextGray, fontSize: 13),
            ),
            const SizedBox(height: 20),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('OK', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
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
          'Deposit',
          style: TextStyle(color: kTextDark, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildSection(
              title: 'Informasi Pengirim',
              children: [
                _buildField(
                  label: 'Nama Pengirim',
                  hint: 'Masukkan nama pengirim',
                  controller: _namaPengirimCtrl,
                ),
                _divider(),
                _buildField(
                  label: 'Nama Bank',
                  hint: 'Contoh: BCA, Mandiri, BNI',
                  controller: _namaBankCtrl,
                ),
                _divider(),
                _buildField(
                  label: 'No. Rekening',
                  hint: 'Masukkan nomor rekening',
                  controller: _noRekeningCtrl,
                  inputType: TextInputType.number,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildSection(
              title: 'Jumlah Deposit',
              children: [
                _buildAmountField(),
              ],
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isValid ? _onKonfirmasi : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                    disabledForegroundColor: kTextGray,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Konfirmasi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kTextDark),
            ),
          ),
          ...children,
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: kTextGray)),
          TextField(
            controller: controller,
            keyboardType: inputType,
            inputFormatters: formatters,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
            style: const TextStyle(fontSize: 14, color: kTextDark),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Jumlah', style: TextStyle(fontSize: 12, color: kTextGray)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                'Rp',
                style: TextStyle(fontSize: 14, color: kTextDark, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: _jumlahCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ThousandSeparatorFormatter(),
                  ],
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 22),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  style: const TextStyle(fontSize: 22, color: kTextDark, fontWeight: FontWeight.w500),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          ValueListenableBuilder<int>(
            valueListenable: tabunganNotifier,
            builder: (context, val, child) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Saldo tersedia: ${formatRp(val)}',
                style: const TextStyle(color: kTextGray, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: kDivider, indent: 16, endIndent: 16);
}

class _ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue _, TextEditingValue next) {
    final digits = next.text.replaceAll('.', '');
    if (digits.isEmpty) return next.copyWith(text: '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buf.write('.');
      buf.write(digits[i]);
    }
    final formatted = buf.toString();
    return next.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
