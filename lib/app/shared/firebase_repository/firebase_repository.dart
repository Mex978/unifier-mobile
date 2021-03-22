import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifier_mobile/app/shared/exceptions/user_not_found.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

class FirebaseRepository {
  late FirebaseFirestore instance = FirebaseFirestore.instance;

  Future<DocumentSnapshot> loadUser({
    String? username,
    required String token,
  }) async {
    final docRef = instance.collection('users').doc(token);
    final doc = await docRef.get();

    if (doc.exists) return doc;

    Unifier.errorNotification(content: UserNotFound().cause);
    throw UserNotFound();
  }

  Future<DocumentSnapshot> createUser({
    required Map<String, String> data,
    required String token,
  }) async {
    final docRef = instance.collection('users').doc(token);
    final doc = await docRef.get();

    if (doc.exists) return doc;

    await docRef.set(
      data,
      SetOptions(merge: true),
    );

    return await docRef.get();
  }
}
