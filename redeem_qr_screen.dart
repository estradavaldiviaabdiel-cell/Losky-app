import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RedeemQRScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    String qrPayload = '';
    String signature = '';

    if (args != null) {
      final signed = args as Map;
      // some endpoints return qr_payload as JSON string
      final s = signed is String ? jsonDecode(signed) : signed;
      qrPayload = s['payload'] ?? '';
      signature = s['signature'] ?? '';
    }

    final display = jsonEncode({'payload': qrPayload, 'signature': signature});

    return Scaffold(
      appBar: AppBar(title: Text('Tu cupón')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(data: display, size: 260),
            SizedBox(height: 16),
            Text('Muestra este QR en caja para canjear.'),
          ],
        ),
      ),
    );
  }
}