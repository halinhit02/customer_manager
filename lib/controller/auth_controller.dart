import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../util/app_constants.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  bool isAdmin() {
    return (getCurrentUser()?.email ?? '').contains('admin');
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? e.code);
    } catch (e) {
      print(e.toString());
      return Future.error(AppConstants.errorOccurred);
    }
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
