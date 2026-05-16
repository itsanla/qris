import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const SeaBankApp());
}

const kOrange = Color(0xFFE8731A);
const kDarkOrange = Color(0xFFC55A00);
const kFlashBg = Color(0xFFFEF0E5);
const kBgGray = Color(0xFFF3F3F3);
const kTextGray = Color(0xFF757575);
const kTextDark = Color(0xFF212121);
const kGreen = Color(0xFF00A651);
const kBlue = Color(0xFF1565C0);
const kDivider = Color(0xFFE0E0E0);

class SeaBankApp extends StatelessWidget {
  const SeaBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeaBank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: false,
        primaryColor: kOrange,
        scaffoldBackgroundColor: kBgGray,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    TransferScreen(),
    SizedBox(),
    SizedBox(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _SeaBankBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) {
          if (i == 2) return;
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}

class _SeaBankBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _SeaBankBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          _NavItem(icon: Icons.home, label: 'Beranda', index: 0, current: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.compare_arrows, label: 'Bayar/Transfer', index: 1, current: currentIndex, onTap: onTap),
          _QrisButton(onTap: () => onTap(2)),
          _NavItem(icon: Icons.account_balance_wallet_outlined, label: 'Deposito', index: 3, current: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.person_outline, label: 'Saya', index: 4, current: currentIndex, onTap: onTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = current == index;
    final color = active ? kOrange : const Color(0xFF9E9E9E);
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QrisButton extends StatelessWidget {
  final VoidCallback onTap;
  const _QrisButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 2),
            const Text('QRIS', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class BellButton extends StatelessWidget {
  final bool onOrange;
  const BellButton({super.key, this.onOrange = false});

  @override
  Widget build(BuildContext context) {
    final borderColor = onOrange ? Colors.white : const Color(0xFFBDBDBD);
    final iconColor = onOrange ? Colors.white : kTextDark;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Icon(Icons.notifications_none, color: iconColor, size: 20),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: kOrange,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: const Text('...', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, height: 1)),
          ),
        ),
      ],
    );
  }
}
