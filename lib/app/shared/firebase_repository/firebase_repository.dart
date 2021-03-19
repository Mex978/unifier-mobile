import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unifier_mobile/app/shared/exceptions/user_not_found.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

class FirebaseRepository {
  late FirebaseFirestore instance = FirebaseFirestore.instance;
  Future<DocumentSnapshot> loadUser({
    String? username,
    required String token,
    bool create = false,
  }) async {
    final docRef = instance.collection('users').doc(token);
    final doc = await docRef.get();

    if (doc.exists)
      return doc;
    else if (create) {
      await docRef.set({'username': username ?? ''});
      return await docRef.get();
    } else {
      Unifier.errorNotification(content: UserNotFound().cause);
      throw UserNotFound();
    }
  }
}
