//これは枠だけ（Provider/Riverpod共通）
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Repository {
  Future<bool> sendData(String id, String name) async {
    //データ処理（DBへの格納等）=> ここではダミーで２秒間待つ
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}

final repositoryProvider = Provider<Repository>((ref) => Repository());