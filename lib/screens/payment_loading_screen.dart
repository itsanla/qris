import 'package:flutter/material.dart';
import '../main.dart';
import '../state/transaction_store.dart';
import 'payment_success_screen.dart';

class PaymentLoadingScreen extends StatefulWidget {
  final TransactionItem transaction;
  const PaymentLoadingScreen({super.key, required this.transaction});

  @override
  State<PaymentLoadingScreen> createState() => _PaymentLoadingScreenState();
}

class _PaymentLoadingScreenState extends State<PaymentLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateCtrl;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, a1, a2) => PaymentSuccessScreen(transaction: widget.transaction),
          transitionsBuilder: (ctx, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    });
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(color: kOrange, shape: BoxShape.circle),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 36),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: kOrange,
                strokeWidth: 3.5,
                value: null,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Memproses pembayaran...',
              style: TextStyle(color: kTextGray, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              widget.transaction.name,
              style: const TextStyle(color: kTextDark, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Rp ${widget.transaction.amountValue}',
              style: const TextStyle(color: kOrange, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
