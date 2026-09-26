import 'package:flutter/material.dart';
import 'package:bank_and_more/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(const BankAndMoreApp());
}
