import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future<bool> saveQrisToGallery(String rawValue, String merchantName) async {
  try {
    final hasAccess = await Gal.hasAccess(toAlbum: true);
    if (!hasAccess) {
      final granted = await Gal.requestAccess(toAlbum: true);
      if (!granted) return false;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 512.0;

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, size, size),
      Paint()..color = const Color(0xFFFFFFFF),
    );

    final qrPainter = QrPainter(
      data: rawValue,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Color(0xFF000000),
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Color(0xFF000000),
      ),
    );
    qrPainter.paint(canvas, const Size(size, size));

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return false;

    final bytes = byteData.buffer.asUint8List();
    await Gal.putImageBytes(bytes, album: 'SeaBank');
    return true;
  } catch (_) {
    return false;
  }
}
