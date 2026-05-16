import 'package:flutter/material.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showFingerprint = true;
  bool _showEmailVerify = true;

  final _menuItems = const [
    _MenuItem(icon: Icons.person_outline, label: 'Profil Saya'),
    _MenuItem(icon: Icons.shield_outlined, label: 'Keamanan Akun'),
    _MenuItem(icon: Icons.receipt_long_outlined, label: 'e-Statement'),
    _MenuItem(icon: Icons.credit_card_outlined, label: 'Pengaturan Limit dan Pembayaran'),
    _MenuItem(icon: Icons.phonelink_outlined, label: 'Pengaturan BI-FAST'),
    _MenuItem(icon: Icons.settings_outlined, label: 'Pengaturan Umum'),
    _MenuItem(icon: Icons.group_add_outlined, label: 'Undang Teman'),
    _MenuItem(icon: Icons.lightbulb_outline, label: 'Pusat Bantuan'),
    _MenuItem(icon: Icons.chat_bubble_outline, label: 'Chat dengan SeaBank'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGray,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  if (_showFingerprint) _buildNotificationCard(
                    title: 'Log in dengan sidik jari',
                    body: 'Aktifkan verifikasi sidik jari untuk log in lebih cepat\ndan aman tanpa password!',
                    linkText: 'Aktifkan Sekarang',
                    onClose: () => setState(() => _showFingerprint = false),
                  ),
                  if (_showEmailVerify) _buildNotificationCard(
                    title: 'Verifikasi Email Kamu Sekarang',
                    body: 'Dapatkan info transaksi & promo, serta pulihkan\npassword dengan mudah!',
                    linkText: 'Verifikasi Email',
                    onClose: () => setState(() => _showEmailVerify = false),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuList(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: kOrange,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [BellButton(onOrange: true)],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF6B3FA0),
                child: const Icon(Icons.person, color: Colors.white, size: 34),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Anla Harpanda',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '082*******525',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String body,
    required String linkText,
    required VoidCallback onClose,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: kOrange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications, color: kOrange, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: kTextDark)),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(color: kTextGray, fontSize: 12, height: 1.4)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {},
                  child: Text(linkText, style: const TextStyle(color: kBlue, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.close, size: 18, color: kTextGray),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: Column(
        children: List.generate(_menuItems.length, (i) {
          final item = _menuItems[i];
          return Column(
            children: [
              GestureDetector(
                onTap: () {},
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(item.icon, color: kTextDark, size: 22),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(item.label, style: const TextStyle(fontSize: 14, color: kTextDark, fontWeight: FontWeight.w400)),
                      ),
                      const Icon(Icons.chevron_right, color: kTextGray, size: 20),
                    ],
                  ),
                ),
              ),
              if (i < _menuItems.length - 1)
                const Divider(height: 1, color: kDivider, indent: 52),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem({required this.icon, required this.label});
}
