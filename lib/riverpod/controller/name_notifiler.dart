import 'package:hooks_riverpod/hooks_riverpod.dart';

//ChangeNotifier時代の「name」だけを監視するStateNotifier（task_customer.notifier.dart参考）
// => ChangeNotifierは複数のプロパティをまとめて監視できたが、StateNotifier（ValueNotifier）は１つだけしかできないため
class NameNotifier extends StateNotifier<String> {
  //StateNotifierは初期値の設定要
  NameNotifier(): super("");

  void update(String updatedName) {
    state = updatedName;
  }

  void delete() {
    state = "";
  }
}

final nameProvider = StateNotifierProvider<NameNotifier, String>((ref) => NameNotifier());