import 'package:fashion/features/auth/views/login_view.dart';
import 'package:fashion/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

part 'core/utils/init/core_init.dart';

Future<void> main() async {
  await _CoreInit().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginView(),
    );
  }
}
