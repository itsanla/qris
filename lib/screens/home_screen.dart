import 'package:flutter/material.dart';
import '../main.dart';
import '../state/balance_store.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildBalanceCard(context),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildMenuGrid(),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildFlashDeals(),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildLoanCard(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/Profile.png',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Anla Harpanda',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kTextDark),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Text(
                      'No. Rekening: 9014 1469 0015',
                      style: TextStyle(fontSize: 12, color: kTextGray),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.copy, size: 13, color: kTextGray),
                  ],
                ),
              ],
            ),
          ),
          const BellButton(onOrange: false),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kOrange,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Opacity(
              opacity: 0.15,
              child: Text(
                'S',
                style: TextStyle(
                  fontSize: 160,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Total Saldo',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.remove_red_eye_outlined, color: Colors.white70, size: 16),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC05000),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Riwayat', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            SizedBox(width: 2),
                            Icon(Icons.chevron_right, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<int>(
                  valueListenable: tabunganNotifier,
                  builder: (context, tabungan, child) => Text(
                    formatRp(tabungan + depositoBalance),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 1,
                  color: Colors.white24,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text('Tabungan', style: TextStyle(color: Colors.white, fontSize: 12)),
                              SizedBox(width: 2),
                              Icon(Icons.chevron_right, color: Colors.white, size: 14),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ValueListenableBuilder<int>(
                            valueListenable: tabunganNotifier,
                            builder: (context, val, child) => Text(
                              formatRp(val),
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '2,5% p.a. cair harian',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 50, color: Colors.white24),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text('Deposito', style: TextStyle(color: Colors.white, fontSize: 12)),
                                SizedBox(width: 2),
                                Icon(Icons.chevron_right, color: Colors.white, size: 14),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Rp 5.181.656',
                              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Hingga 6% p.a.',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    const items = [
      _MenuItem(icon: Icons.currency_exchange, label: 'Transfer'),
      _MenuItem(icon: Icons.receipt_long, label: 'Top Up &\nTagihan'),
      _MenuItem(icon: Icons.account_balance_wallet_outlined, label: 'Top Up\nE-Wallet'),
      _MenuItem(icon: Icons.group_add_outlined, label: 'Undang Teman'),
      _MenuItem(icon: Icons.savings_outlined, label: 'Deposito'),
      _MenuItem(icon: Icons.download_outlined, label: 'Tarik Tunai'),
      _MenuItem(icon: Icons.monetization_on_outlined, label: 'Pinjaman'),
      _MenuItem(icon: Icons.apps, label: 'Lihat Semua'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Column(
        children: [
          Row(
            children: items.sublist(0, 4).map((item) => Expanded(child: _buildMenuItem(item))).toList(),
          ),
          const SizedBox(height: 4),
          Row(
            children: items.sublist(4, 8).map((item) => Expanded(child: _buildMenuItem(item))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              border: Border.all(color: kOrange.withValues(alpha: 0.3), width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: kOrange, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: const TextStyle(fontSize: 11, color: kTextDark, height: 1.2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFlashDeals() {
    return Container(
      decoration: BoxDecoration(
        color: kFlashBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: kOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.timer_outlined, color: kOrange, size: 18),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Deposito Flash Deals',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kTextDark),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: kOrange, width: 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Kamis 19.00 WIB',
                    style: TextStyle(color: kOrange, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_up, color: kTextDark, size: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
            child: Row(
              children: [
                Expanded(child: _buildDealCard('12 bulan', '7,?', '6,00', '100')),
                const SizedBox(width: 8),
                Expanded(child: _buildDealCard('6 bulan', '6,?', '5,25', '800')),
                const SizedBox(width: 8),
                Expanded(child: _buildDealCard('3 bulan', '5,?', '4,75', '1.300')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(String period, String rate, String oldRate, String quota) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(period, style: const TextStyle(fontSize: 12, color: kTextDark, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: kOrange),
              children: [
                TextSpan(
                  text: rate,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kOrange),
                ),
                const TextSpan(text: '% p.a.', style: TextStyle(fontSize: 12, color: kOrange)),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$oldRate% p.a.',
            style: const TextStyle(
              fontSize: 11,
              color: kTextGray,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$quota kuota',
            style: const TextStyle(fontSize: 11, color: kOrange),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'SeaBank Pinjam',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kTextDark),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Bunga rendah mulai dari 1.60%',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Dapatkan limit hingga', style: TextStyle(color: kTextGray, fontSize: 13)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  'Rp 30.000.000',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: kTextDark),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  elevation: 0,
                ),
                child: const Text('Ajukan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildChip('Pencairan Instan'),
              const SizedBox(width: 8),
              _buildChip('Bebas Biaya Admin'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: kBlue.withValues(alpha: 0.5), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: kBlue, fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});
}
