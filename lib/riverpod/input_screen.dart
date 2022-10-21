import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_provider_comparison_sample/riverpod/controller/id_notifiler.dart';
import 'package:riverpod_provider_comparison_sample/riverpod/controller/input_controller.dart';
import 'package:riverpod_provider_comparison_sample/riverpod/controller/name_notifiler.dart';

//RiverPodで実装
/*
* HookConsumerWidgetでref.watchするとProviderでいうcontext.watchとおなじになって
* buildメソッド全体がリビルドされる感じになってしまうが、riverPodではこっちの方がメインの
* 使い方のようなのでそのようにしておきます（FABやAppBarもリビルドされます）。
* ですので、RiverPodではAnjeraさんの言うように、Widgetクラスをなるべく小さくしておく必要があります。
* （ConsumerではなくHookConsumerWidgetを使うのであれば）
*   https://codewithandrea.com/articles/flutter-state-management-riverpod/#2-using-a-consumer
*   If you follow this principle and create small, reusable widgets,
*   then you'll naturally use ConsumerWidget most of the time.
*
* */
class InputScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TextEditingControllerをHook
    final _idController = useTextEditingController();
    final _nameController = useTextEditingController();

    final result = ref.watch(inputControllerProvider);
    final loading = result is AsyncLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text("Provider"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _idController.clear();
          _nameController.clear();
          _clearResult(ref);
        },
        child: Icon(Icons.refresh),
      ),
      //RiverPodのConsumer
      //https://codewithandrea.com/articles/flutter-state-management-riverpod/#1-using-a-consumerwidget
      //
      body: (loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _idController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "id入れてね",
                      border: OutlineInputBorder(),
                    ),
                    /*
                        * センキャクのPT（sign_up_login.dartとか）を見たら、
                        * onFieldSubmitted（TextFieldでいうonSubmitted）でやっているので
                        * addListener方式でやらなくて良さそう（変更確定時にやればいい）
                        * => onFieldSubmittedはテキストを入力して「完了」ボタンを押してキーボードが閉じられないと呼ばれない
                        * => onChangedはテキストを変更するたびに呼ばれる
                        *   （個人的には複数のフィールドがある場合は「onChanged」の方がいいような気がするので
                        *     このサンプルでは「onFieldSubmitted」ではなく「onChanged」で実装しておきます）
                        *   ※ addListener方式とonChanged方式の違いは以下ご参照（中級編２）
                        *   https://school.minpro.net/courses/flutter-ios-android03/lectures/34840576
                        * */
                    onChanged: (id) => _onIdChanged(ref, id),
                    //onFieldSubmitted: (id) => _onIdChanged(context, id),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "名前入れてね",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (name) => _onNameChanged(ref, name),
                    //onFieldSubmitted: (name) => _onNameChanged(context, name),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    child: Text("送信する"),
                    onPressed: () => _sendData(ref),
                  ),
                  SizedBox(height: 32.0),
                  //AsyncValue.valueはnull許容
                  Text(
                    result.value ?? "",
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
    );
  }

  void _onIdChanged(WidgetRef ref, String id) {
    print("_onIdChanged: $id");
    final idNotifier = ref.read(idProvider.notifier);
    idNotifier.update(id);
  }

  void _onNameChanged(WidgetRef ref, String name) {
    print("_onNameChanged: $name");
    final nameNotifier = ref.read(nameProvider.notifier);
    nameNotifier.update(name);
  }

  _sendData(WidgetRef ref) {
    final inputController = ref.read(inputControllerProvider.notifier);
    //id・nameは別のStateNotifierで保持しているのでView側から引数として渡してやる
    final id = ref.read(idProvider);
    final name = ref.read(nameProvider);
    inputController.sendData(id, name);
  }

  _clearResult(WidgetRef ref) {
    final inputController = ref.read(inputControllerProvider.notifier);
    inputController.clearResult();
  }
}
