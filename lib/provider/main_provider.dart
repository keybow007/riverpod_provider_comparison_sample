import 'package:flutter/material.dart';
import 'package:riverpod_provider_comparison_sample/common/repository.dart';
import 'package:riverpod_provider_comparison_sample/provider/controller/input_controller.dart';
import 'package:riverpod_provider_comparison_sample/provider/input_screen.dart';

import 'package:provider/provider.dart';

/*
* providerはピュアにprovider＋ChangeNotifierのシンプルなパターン（hookも無し）
* */

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<Repository>(
          create: (_) => Repository(),
        ),
        ChangeNotifierProvider(
          create: (context) => InputController(
            repository: context.read<Repository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InputScreen(),
    );
  }
}
