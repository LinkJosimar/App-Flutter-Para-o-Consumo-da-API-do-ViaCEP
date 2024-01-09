import 'package:cadastro_viacep/viacep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

Future main() async {
  await dotenv.dotenv.load(fileName: ".env");
  runApp(const AppViaCep());
}
