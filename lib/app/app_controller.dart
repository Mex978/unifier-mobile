import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';

class AppController with Disposable {
  final value = RxNotifier<int>(0);

  late FirebaseAuth auth = FirebaseAuth.instance;

  void increment() {
    value.value++;
  }

  @override
  void dispose() {}
}
