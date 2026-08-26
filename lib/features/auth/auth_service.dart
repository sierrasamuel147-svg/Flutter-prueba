import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn =
      GoogleSignIn.instance;

  static const String _serverClientId =
      '646580884446-7hfebf3203cpjcp5tn8rgcqb4nrsscsb.apps.googleusercontent.com';

  bool _initialized = false;

  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  User? get currentUser =>
      _firebaseAuth.currentUser;

  Future<void> _initializeGoogleSignIn() async {
    if (_initialized) return;

    await _googleSignIn.initialize(
      serverClientId: _serverClientId,
    );

    _initialized = true;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _initializeGoogleSignIn();

      final googleUser =
          await _googleSignIn.authenticate();

      final googleAuth =
          googleUser.authentication;

      final credential =
          GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth
          .signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception(
        'No se pudo iniciar sesión con Google: $e',
      );
    }
  }

  Future<void> signOut() async {
    await _initializeGoogleSignIn();

    await _googleSignIn.signOut();

    await _firebaseAuth.signOut();
  }
}