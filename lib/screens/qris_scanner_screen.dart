import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../main.dart';
import 'qris_confirm_screen.dart';

class QrisScannerScreen extends StatefulWidget {
  const QrisScannerScreen({super.key});

  @override
  State<QrisScannerScreen> createState() => _QrisScannerScreenState();
}

class _QrisScannerScreenState extends State<QrisScannerScreen> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _detected = false;
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_detected) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;
    _detected = true;
    _controller.stop();
    final parsed = _parseQris(barcode!.rawValue!);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QrisConfirmScreen(data: parsed, rawValue: barcode.rawValue!)),
      ).then((_) {
        _detected = false;
        _controller.start();
      });
    });
  }

  QrisData _parseQris(String raw) {
    String merchantName = 'Merchant';
    String city = '';
    double amount = 0;
    bool hasAmount = false;

    int i = 0;
    while (i + 4 <= raw.length) {
      final tag = raw.substring(i, i + 2);
      final length = int.tryParse(raw.substring(i + 2, i + 4)) ?? 0;
      if (length == 0) {
        i += 4;
        continue;
      }
      if (i + 4 + length > raw.length) break;
      final value = raw.substring(i + 4, i + 4 + length);
      switch (tag) {
        case '54':
          final a = double.tryParse(value) ?? 0;
          if (a > 0) {
            amount = a;
            hasAmount = true;
          }
        case '59':
          merchantName = value;
        case '60':
          city = value;
      }
      i += 4 + length;
    }
    return QrisData(
      merchantName: merchantName.isEmpty ? 'Merchant' : merchantName,
      city: city,
      amount: amount,
      hasAmount: hasAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          _ScanOverlay(),
          _buildHeader(context),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Scan QRIS',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black.withValues(alpha: 0.75),
        padding: const EdgeInsets.fromLTRB(0, 14, 0, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomBarItem(
              icon: Icons.flash_on,
              label: 'Flash',
              onTap: () async {
                setState(() => _torchOn = !_torchOn);
                await _controller.toggleTorch();
              },
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.qr_code, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Tampilkan QR', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            _BottomBarItem(
              icon: Icons.photo_library_outlined,
              label: 'Galeri',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final scanSize = w * 0.72;
        final scanLeft = (w - scanSize) / 2;
        final scanTop = h * 0.22;
        final scanRect = Rect.fromLTWH(scanLeft, scanTop, scanSize, scanSize * 1.1);
        return Stack(
          children: [
            CustomPaint(
              size: Size(w, h),
              painter: _OverlayPainter(scanRect),
            ),
            Positioned(
              left: scanRect.left + scanRect.width / 2 - 80,
              top: scanRect.bottom + 16,
              child: Row(
                children: [
                  const Text(
                    'Scan Kode ',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      'QRIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect scanRect;
  _OverlayPainter(this.scanRect);

  @override
  void paint(Canvas canvas, Size size) {
    final dark = Paint()..color = Colors.black.withValues(alpha: 0.65);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRect(scanRect),
      ),
      dark,
    );

    const corner = 28.0;
    const thick = 3.5;
    final cornerPaint = Paint()
      ..color = kOrange
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    void drawCorner(Offset a, Offset b, Offset c) {
      canvas.drawLine(a, b, cornerPaint);
      canvas.drawLine(b, c, cornerPaint);
    }

    final l = scanRect.left;
    final t = scanRect.top;
    final r = scanRect.right;
    final b = scanRect.bottom;

    drawCorner(Offset(l, t + corner), Offset(l, t), Offset(l + corner, t));
    drawCorner(Offset(r - corner, t), Offset(r, t), Offset(r, t + corner));
    drawCorner(Offset(l, b - corner), Offset(l, b), Offset(l + corner, b));
    drawCorner(Offset(r - corner, b), Offset(r, b), Offset(r, b - corner));
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _BottomBarItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

class QrisData {
  final String merchantName;
  final String city;
  final double amount;
  final bool hasAmount;

  const QrisData({
    required this.merchantName,
    required this.city,
    required this.amount,
    required this.hasAmount,
  });
}
