import 'package:hooks_riverpod/hooks_riverpod.dart';

//ChangeNotifier時代の「id」だけを監視するStateNotifier（task_customer.notifier.dart参考）
// => ChangeNotifierは複数のプロパティをまとめて監視できたが、StateNotifier（ValueNotifier）は１つだけしかできないため
class IdNotifier extends StateNotifier<String> {
  //StateNotifierは初期値の設定要
  IdNotifier(): super("");

  void update(String updatedId) {
    state = updatedId;
  }

  void delete() {
    state = "";
  }
}

final idProvider = StateNotifierProvider<IdNotifier, String>((ref) => IdNotifier());