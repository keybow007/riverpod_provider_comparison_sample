import 'package:flutter/material.dart';
import 'package:riverpod_provider_comparison_sample/common/repository.dart';

//ChangeNotifierで実装
class InputController extends ChangeNotifier {
  final Repository repository;

  InputController({required this.repository});

  String id = "";
  String name = "";
  String result = "";

  bool isLoading = false;

  Future<void> sendData() async {
    isLoading = true;
    notifyListeners();

    final isSuccessful = await repository.sendData(id, name);
    result = isSuccessful ? "成功: $id / $name" : "失敗";

    isLoading = false;

    notifyListeners();
  }

  void clearResult() {
    result = "";
    notifyListeners();
  }
}
