import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:tic_tac_toe/services/firestore_service.dart';

void main() {
  test("Create user if not exists", () async {
    final fakeDb = FakeFirebaseFirestore();
    final service = FirestoreService.withInstance(fakeDb);


    final mockUser = MockUser(
      uid: "123",
      email: "test@example.com",
    );

    await service.createUserIfNotExists(mockUser);

    final doc = await fakeDb.collection("users").doc("123").get();
    expect(doc.exists, true);
    expect(doc.data()?["scores"]["wins"], 0);
  });
}
