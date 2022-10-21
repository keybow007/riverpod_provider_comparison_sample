import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'input_screen.dart';

/*
* riverpodはriverpod＋hook＋state_notifierのプロ向けパターン
* */

void main() {
  runApp(
    //ChangeNotifierProvider => ProviderScope
    ProviderScope(
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
