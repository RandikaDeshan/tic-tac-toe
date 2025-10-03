import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;


  factory FirestoreService.withInstance(FirebaseFirestore db) {
    return FirestoreService(db: db);
  }

  Future<void> createUserIfNotExists(User user) async {
    final docRef = _db.collection("users").doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        "email": user.email,
        "createdAt": FieldValue.serverTimestamp(),
        "scores": {"wins": 0, "losses": 0, "draws": 0}
      });
    }
  }

  Future<Map<String, dynamic>?> getScores(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      return data?["scores"] ?? {"wins": 0, "losses": 0, "draws": 0};
    }
    return null;
  }

  Future<void> incrementStat(String uid, String stat) async {
    final docRef = _db.collection("users").doc(uid);
    await docRef.set({
      "scores": {stat: FieldValue.increment(1)}
    }, SetOptions(merge: true));
  }

  Future<void> resetScores(String uid) async {
    final docRef = _db.collection("users").doc(uid);
    await docRef.set({
      "scores": {"wins": 0, "losses": 0, "draws": 0}
    }, SetOptions(merge: true));
  }
}
