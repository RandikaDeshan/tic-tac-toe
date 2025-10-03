import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();


  Stream<User?> get userChanges => _auth.authStateChanges();


  User? get currentUser => _auth.currentUser;


  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user != null) {

        await _firestore.createUserIfNotExists(user);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Error registering user");
    }
  }


  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user != null) {
        await _firestore.createUserIfNotExists(user);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Error signing in");
    }
  }


  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;
      if (user != null) {
        await _firestore.createUserIfNotExists(user);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Google sign-in failed");
    }
  }


  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Error sending password reset email");
    }
  }


  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      throw Exception("Error signing out: $e");
    }
  }
}
