import 'package:flutter/material.dart';
import 'pages/viacep_page.dart';

class AppViaCep extends StatelessWidget {
  const AppViaCep({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const ViaCepPage(),
    );
  }
}
