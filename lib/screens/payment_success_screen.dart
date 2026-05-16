import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../state/transaction_store.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final TransactionItem transaction;
  const PaymentSuccessScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 8),
                    _buildDetailCard(context),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Text(
        'Hasil Transfer',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: kTextDark),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: kBgGray,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF2ECC71),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 34),
          ),
          const SizedBox(height: 10),
          const Text(
            'Pembayaran Diterima',
            style: TextStyle(color: kTextGray, fontSize: 13),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Rp ',
                  style: TextStyle(
                    color: kTextDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: transaction.amountValue,
                  style: const TextStyle(
                    color: kTextDark,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      color: Colors.white,
      child: Column(
        children: [
          _buildDariRow(),
          _divider(),
          _buildKeRow(),
          _divider(),
          _buildAcquirerRow(),
          _divider(),
          _buildSimpleRow('Nominal Transaksi', 'Rp ${transaction.amountValue}'),
          _divider(),
          _buildBiayaRow(),
          _divider(),
          _buildSimpleRow('Jumlah Total', 'Rp ${transaction.amountValue}'),
          _divider(),
          _buildCopyRow(context, 'No. Transaksi', transaction.txNumber ?? '-'),
          _divider(),
          _buildCopyRow(context, 'No. Referensi', transaction.refNumber ?? '-'),
          _divider(),
          _buildSimpleRow('Terminal ID', transaction.terminalId ?? '-'),
          _divider(),
          _buildSimpleRow('Waktu Transaksi', transaction.date),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildDariRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 120,
            child: Text('Dari', style: TextStyle(color: kTextGray, fontSize: 13)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: const Color(0xFF6B3FA0),
                      child: const Icon(Icons.person, color: Colors.white, size: 13),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Anla Harpanda',
                      style: TextStyle(fontSize: 14, color: kTextDark, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                      child: const Center(
                        child: Text('S', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('SeaBank: 901414690015', style: TextStyle(fontSize: 11, color: kTextGray)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 120,
            child: Text('Ke', style: TextStyle(color: kTextGray, fontSize: 13)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                      child: const Icon(Icons.storefront, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        transaction.toName ?? transaction.name,
                        style: const TextStyle(fontSize: 14, color: kTextDark, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                if ((transaction.toLocation ?? '').isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    transaction.toLocation!,
                    style: const TextStyle(fontSize: 12, color: kTextGray),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcquirerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 120,
            child: Text('Nama Acquirer', style: TextStyle(color: kTextGray, fontSize: 13)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.acquirer ?? '-',
                  style: const TextStyle(fontSize: 13, color: kTextDark),
                ),
                if ((transaction.acquirerAccount ?? '').isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.acquirerAccount!,
                    style: const TextStyle(fontSize: 11, color: kTextGray),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiayaRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('Biaya Transaksi', style: TextStyle(color: kTextGray, fontSize: 13)),
          Text(
            'GRATIS',
            style: TextStyle(fontSize: 13, color: Color(0xFF2ECC71), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: kTextGray, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, color: kTextDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: kTextGray, fontSize: 13)),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12, color: kTextDark),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Disalin!'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(Icons.copy, size: 14, color: kTextGray),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: kDivider, indent: 16, endIndent: 16);

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: kOrange,
                side: const BorderSide(color: kOrange, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Bagikan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kOrange),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
