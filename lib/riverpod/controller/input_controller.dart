import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_provider_comparison_sample/common/repository.dart';
import 'package:riverpod_provider_comparison_sample/riverpod/controller/id_notifiler.dart';

//ChangeNotifier => StateProviderに（resultを監視・それ以外のプロパティは別のStateNotifierに）
class InputController extends StateNotifier<AsyncValue<String?>> {
  final Repository repository;

  InputController({required this.repository}) : super(AsyncValue.data(""));

  String result = "";

  //id・nameは別のStateNotifierで保持しているのでView側から引数として渡してやる
  Future<void> sendData(String id, String name) async {
    //RiverPodで非同期処理開始時のお作法（member_controller.dart参考）
    //https://codewithandrea.com/articles/loading-error-states-state-notifier-async-value/#managing-loading-and-error-states-with-asyncvalue
    state = const AsyncLoading();

    state = await AsyncValue.guard<String>(() async {
      final isSuccessful = await repository.sendData(id, name);
      return isSuccessful ? "成功: $id / $name" : "失敗";
    });

  }

  void clearResult() {
    state = AsyncValue.data("");
  }
}

final inputControllerProvider = StateNotifierProvider<InputController, AsyncValue<String?>>((ref) {
  final repository = ref.read(repositoryProvider);
  return InputController(repository: repository);
});