import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/shared/firebase_repository/firebase_repository.dart';
import 'package:unifier_mobile/app/shared/local_data/local_data.dart';
import 'package:unifier_mobile/app/shared/repositories/app_repository.dart';

class AppController with Disposable {
  final AppRepository _repository;
  final FirebaseRepository _firebase;

  AppController(this._repository, this._firebase);

  final token = RxNotifier<String>('');

  Future<void> loadUser() async {
    token.value = await LocalData.readToken();
    await _firebase.loadUser(token: token.value).then((doc) {
      user = doc;
    }).catchError((_) {});
  }

  late DocumentSnapshot user;

  Future<void> login({
    required String username,
    required String password,
    bool create = false,
  }) async {
    final response =
        await _repository.authToken(username: username, password: password);

    token.value = response['token'];

    await _firebase
        .loadUser(
      username: username,
      token: token.value,
    )
        .then((doc) {
      user = doc;
      LocalData.saveToken(token.value);
      Modular.to.popUntil((r) => r.isFirst);
      Modular.to.pushReplacementNamed('/home');
    }).catchError((_) {});
  }

  Future<void> register({
    required String name,
    required String username,
    required String password,
    required String email,
  }) async {
    final response = await _repository.createUser(
      username: username,
      password: password,
      email: email,
    );

    token.value = response['token'];

    await _firebase.createUser(
      data: {
        "name": name,
        "username": username,
      },
      token: token.value,
    ).then((doc) {
      user = doc;
      LocalData.saveToken(token.value);
      Modular.to.popUntil((r) => r.isFirst);
      Modular.to.pushReplacementNamed('/home');
    }).catchError((_) {});
  }

  @override
  void dispose() {}
}
