import 'package:flutter/material.dart';
import '../main.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String merchantName;
  final String amount;
  const PaymentSuccessScreen({super.key, required this.merchantName, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: kOrange.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, color: kOrange, size: 60),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Pembayaran Berhasil!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kTextDark),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    merchantName,
                    style: const TextStyle(fontSize: 15, color: kTextGray),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    amount,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kTextDark),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: kOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Biaya Transaksi: GRATIS',
                      style: TextStyle(color: kOrange, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Kembali ke Beranda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
