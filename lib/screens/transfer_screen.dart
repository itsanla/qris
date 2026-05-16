import 'package:flutter/material.dart';
import '../main.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int _tabIndex = 0;

  final _recipients = const [
    _Recipient(name: 'Anla Harpanda', bank: 'JAGO', account: '104640433913', isSeaBank: false),
    _Recipient(name: 'Reza Budi Minandha', bank: 'BSI', account: '8683553110', isSeaBank: false),
    _Recipient(name: 'Reza Budi Minandha', bank: 'SeaBank', account: '901870136647', isSeaBank: true),
    _Recipient(name: 'Rp50000', bank: 'PERMATA', account: '871900000239382', isSeaBank: false),
    _Recipient(name: 'Anla Harpanda', bank: 'BANK NAGARI', account: '19030210048776', isSeaBank: false),
    _Recipient(name: 'Axxxxd', bank: 'Virtual Account', account: '12345678', isSeaBank: false, isVA: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTransferKe(),
                  const SizedBox(height: 4),
                  _buildTabs(),
                  _buildSearch(),
                  _buildRecipientList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: kOrange,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      child: Row(
        children: [
          const Text(
            'Bayar/Transfer',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const BellButton(onOrange: true),
        ],
      ),
    );
  }

  Widget _buildTransferKe() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Transfer ke', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kTextDark)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildTransferIcon(_SeaBankIcon(), 'SeaBank')),
                    Expanded(child: _buildTransferIcon(const Icon(Icons.account_balance, color: Colors.white, size: 22), 'Bank Lain')),
                    Expanded(child: _buildTransferIcon(
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 1.5), borderRadius: BorderRadius.circular(4)),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        child: const Text('VA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                      'Virtual\nAccount',
                    )),
                    Expanded(child: _buildTransferIcon(const Icon(Icons.account_balance_wallet, color: Colors.white, size: 22), 'Top Up\nE-Wallet')),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: _buildTransferIcon(const Icon(Icons.receipt_long, color: Colors.white, size: 22), 'Top Up &\nTagihan')),
                    Expanded(child: _buildTransferIcon(const Icon(Icons.groups, color: Colors.white, size: 22), 'Transfer\nGrup')),
                    Expanded(child: _buildTransferIcon(const Icon(Icons.schedule, color: Colors.white, size: 22), 'Transfer\nTerjadwal')),
                    Expanded(child: _buildTransferIcon(const Icon(Icons.qr_code, color: Colors.white, size: 22), 'Tampilkan\nQR Bayar')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferIcon(Widget iconWidget, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
          child: Center(child: iconWidget),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: kTextDark, height: 1.2),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(child: _buildTab('Terakhir', 0)),
          Expanded(child: _buildTab('Favorit', 1)),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final active = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              style: TextStyle(
                color: active ? kOrange : kTextDark,
                fontWeight: active ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            height: 2.5,
            color: active ? kOrange : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Cari penerima di sini',
            hintStyle: TextStyle(color: kTextGray, fontSize: 13),
            prefixIcon: Icon(Icons.search, color: kTextGray, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipientList() {
    return Container(
      color: Colors.white,
      child: Column(
        children: _recipients.map((r) => _buildRecipientItem(r)).toList(),
      ),
    );
  }

  Widget _buildRecipientItem(_Recipient r) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: r.isVA ? kOrange : kOrange,
                  shape: BoxShape.circle,
                ),
                child: r.isVA
                    ? const Center(
                        child: Text('VA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    : const Icon(Icons.person, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: kTextDark)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (r.isSeaBank) ...[
                          Container(
                            width: 14,
                            height: 14,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
                            child: const Center(child: Text('S', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
                          ),
                        ],
                        Text(
                          '${r.bank}: ${r.account}',
                          style: const TextStyle(color: kTextGray, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.star_border, color: Colors.amber.shade300, size: 22),
            ],
          ),
        ),
        Divider(height: 1, color: kDivider, indent: 66),
      ],
    );
  }
}

class _SeaBankIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
        Positioned(
          bottom: 0,
          child: Container(
            width: 26,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );
  }
}

class _Recipient {
  final String name;
  final String bank;
  final String account;
  final bool isSeaBank;
  final bool isVA;
  const _Recipient({
    required this.name,
    required this.bank,
    required this.account,
    this.isSeaBank = false,
    this.isVA = false,
  });
}
