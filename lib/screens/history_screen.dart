import 'package:flutter/material.dart';
import '../main.dart';
import '../state/transaction_store.dart';
import 'transaction_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _showInterest = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildFilters(),
          _buildCheckbox(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.chevron_left, color: kTextDark, size: 28),
      ),
      title: const Text(
        'Riwayat Transaksi',
        style: TextStyle(color: kTextDark, fontWeight: FontWeight.bold, fontSize: 17),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: kDivider, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt_long_outlined, color: kTextDark, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kDivider))),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _buildDropdown('30 Hari Terakhir')),
            const VerticalDivider(width: 1, color: kDivider),
            Expanded(child: _buildDropdown('Semua Transaksi')),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: kTextDark, fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: kTextDark),
        ],
      ),
    );
  }

  Widget _buildCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _showInterest = !_showInterest),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _showInterest ? kOrange : const Color(0xFFBDBDBD),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(3),
                color: _showInterest ? kOrange : Colors.white,
              ),
              child: _showInterest ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Tampilkan bunga & pajak', style: TextStyle(fontSize: 13, color: kTextDark)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ValueListenableBuilder<List<TransactionItem>>(
      valueListenable: transactionStore,
      builder: (context, transactions, _) {
        int totalOut = 0;
        int totalIn = 0;
        for (final tx in transactions) {
          final raw = tx.amountValue.replaceAll('.', '');
          final val = int.tryParse(raw) ?? 0;
          if (tx.isPositive) {
            totalIn += val;
          } else {
            totalOut += val;
          }
        }
        return ListView(
          children: [
            _buildMonthHeader(totalOut, totalIn),
            ...transactions.map((tx) => _buildTransactionItem(tx, context)),
          ],
        );
      },
    );
  }

  Widget _buildMonthHeader(int totalOut, int totalIn) {
    String fmt(int v) {
      final s = v.toString();
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
        buf.write(s[i]);
      }
      return buf.toString();
    }

    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Mei 2026', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kTextDark)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Saldo keluar: Rp ${fmt(totalOut)}', style: const TextStyle(fontSize: 11, color: kTextGray)),
              Text('Saldo masuk: Rp ${fmt(totalIn)}', style: const TextStyle(fontSize: 11, color: kTextGray)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(TransactionItem tx, BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TransactionDetailScreen(transaction: tx)),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                _buildTxIcon(tx.iconType),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tx.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: kTextDark)),
                      const SizedBox(height: 2),
                      Text(tx.category, style: const TextStyle(color: kTextGray, fontSize: 12)),
                      const SizedBox(height: 1),
                      Text(tx.date, style: const TextStyle(color: kTextGray, fontSize: 12)),
                    ],
                  ),
                ),
                Text(
                  tx.amount,
                  style: TextStyle(
                    color: tx.isPositive ? kGreen : kTextDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: kDivider, indent: 66),
      ],
    );
  }

  Widget _buildTxIcon(TxIconType type) {
    Widget child;
    switch (type) {
      case TxIconType.store:
        child = const Icon(Icons.storefront, color: Colors.white, size: 22);
      case TxIconType.person:
        child = const Icon(Icons.person, color: Colors.white, size: 22);
      case TxIconType.shopee:
        child = Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Center(child: Text('S', style: TextStyle(color: kOrange, fontWeight: FontWeight.bold, fontSize: 14))),
        );
      case TxIconType.mytelkomsel:
        child = const Icon(Icons.store, color: Colors.white, size: 22);
    }
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}
