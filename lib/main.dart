import 'package:flutter/material.dart';
import 'home.dart'; // Bu satırla home.dart dosyasını çağırıyoruz

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      debugShowCheckedModeBanner: false,
      home: Calculator(), // Calculator widget'ı ana sayfa olarak ayarlandı
    );
  }
}
