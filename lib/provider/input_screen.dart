import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:riverpod_provider_comparison_sample/provider/controller/input_controller.dart';

//Providerで実装
class InputScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TextEditingControllerの実態はValueNotifier（ひいてはStateNotifier）
    final _idController = TextEditingController();
    final _nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Provider"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _idController.clear();
          _nameController.clear();
          _clearResult(context);
        },
        child: Icon(Icons.refresh),
      ),
      //ProviderのConsumer
      body: Consumer<InputController>(
        builder: (context, controller, child) {
          return (controller.isLoading)
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
                        onChanged: (id) => _onIdChanged(context, id),
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
                        onChanged: (name) => _onNameChanged(context, name),
                        //onFieldSubmitted: (name) => _onNameChanged(context, name),
                      ),
                      SizedBox(height: 32.0),
                      ElevatedButton(
                        child: Text("送信する"),
                        onPressed: () => _sendData(context),
                      ),
                      SizedBox(height: 32.0),
                      Text(
                        controller.result,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }

  void _onIdChanged(BuildContext context, String id) {
    print("_onIdChanged: $id");
    final inputController = context.read<InputController>();
    //プロ向けではこれはダメと言われる可能性あり => riverpodの方でStateNotifier化（中級編１でやったようなカプセル化でもいいんだけど）
    //https://codewithandrea.com/videos/flutter-state-management-setstate-freezed-state-notifier-provider/
    inputController.id = id;
  }

  void _onNameChanged(BuildContext context, String name) {
    print("_onNameChanged: $name");
    final inputController = context.read<InputController>();
    inputController.name = name;
  }

  _sendData(BuildContext context) {
    final inputController = context.read<InputController>();
    inputController.sendData();
  }

  _clearResult(BuildContext context) {
    final inputController = context.read<InputController>();
    inputController.clearResult();
  }
}
