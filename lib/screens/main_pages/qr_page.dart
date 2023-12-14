import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:diploma_work/widgets/bottom_nav_bar.dart';

class QRPage extends StatefulWidget {
  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String qrData = ''; // Данные для генерации QR-кода
  double qrSize = 200.0; // Размер QR-кода

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Убрать кнопку "назад"

        backgroundColor: Colors.white,
        title: Center(
          child: Container(
              child: Text(
            'Создай свой QR code',
            style: TextStyle(color: Colors.black),
          )),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: qrSize,
              height: qrSize,
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (text) {
                setState(() {
                  qrData = text;
                  qrSize = qrData.isEmpty
                      ? 200.0
                      : 250.0; // Изменение размера QR-кода при вводе данных
                });
              },
              decoration: InputDecoration(
                hintText: 'Создайте свой QR code',
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
