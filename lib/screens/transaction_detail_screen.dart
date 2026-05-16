import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../state/transaction_store.dart';

class TransactionDetailScreen extends StatelessWidget {
  final TransactionItem transaction;
  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left, color: kTextDark, size: 28),
        ),
        title: const Text(
          'Rincian Transaksi',
          style: TextStyle(color: kTextDark, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: kTextDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Rp ',
                      style: TextStyle(color: kTextDark, fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: transaction.amountValue,
                      style: const TextStyle(color: kTextDark, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              color: Colors.white,
              child: Column(
                children: [
                  _buildDetailRow(
                    label: 'Dari',
                    right: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: Image.asset('assets/Profile.png', width: 24, height: 24, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Anla Harpanda',
                              style: TextStyle(fontSize: 14, color: kTextDark, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                            const Text(
                              'SeaBank: 901414690015',
                              style: TextStyle(fontSize: 11, color: kTextGray),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildDivider(),
                  _buildDetailRow(
                    label: 'Ke',
                    right: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                              child: const Icon(Icons.storefront, color: Colors.white, size: 16),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              transaction.toName ?? transaction.name,
                              style: const TextStyle(fontSize: 14, color: kTextDark, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        if (transaction.toLocation != null && transaction.toLocation!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              transaction.toLocation!,
                              style: const TextStyle(fontSize: 11, color: kTextGray),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildDivider(),
                  _buildSimpleRow('Nama Acquirer', transaction.acquirer ?? '-'),
                  _buildDivider(),
                  _buildDetailRow(
                    label: 'Metode Pembayaran',
                    right: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                          child: const Center(
                            child: Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('SeaBank', style: TextStyle(fontSize: 14, color: kTextDark)),
                      ],
                    ),
                  ),
                  _buildDivider(),
                  _buildSimpleRow('Jumlah', 'Rp ${transaction.amountValue}'),
                  _buildDivider(),
                  _buildCopyRow('No. Transaksi', transaction.txNumber ?? '-'),
                  _buildDivider(),
                  _buildCopyRow('No. Referensi', transaction.refNumber ?? '-'),
                  _buildDivider(),
                  _buildSimpleRow('Terminal ID', transaction.terminalId ?? '-'),
                  _buildDivider(),
                  _buildSimpleRow('Waktu Transaksi', transaction.date),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Butuh Bantuan?',
                style: TextStyle(color: kBlue, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required Widget right}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(color: kTextGray, fontSize: 13)),
          ),
          Expanded(child: Align(alignment: Alignment.centerRight, child: right)),
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
            width: 130,
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

  Widget _buildCopyRow(String label, String value) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: Text(label, style: const TextStyle(color: kTextGray, fontSize: 13)),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                    child: const Icon(Icons.copy, size: 14, color: kTextGray),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: kDivider, indent: 16, endIndent: 16);
  }
}
