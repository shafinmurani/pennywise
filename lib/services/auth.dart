import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      newUser(
        id: FirebaseAuth.instance.currentUser?.uid,
        data: {
          "name": FirebaseAuth.instance.currentUser?.displayName,
          "email": FirebaseAuth.instance.currentUser?.email,
          "income": [],
          "expenses": [],
          "sources": [],
          "topics": [],
        },
      );
      return "Welcome, ${FirebaseAuth.instance.currentUser?.displayName}";
    } on FirebaseAuthException catch (e) {
      return "Please try again, ${e.message}";
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
  }

  newUser({String? id, required Map<String, dynamic> data}) async {
    final snapShot =
        await FirebaseFirestore.instance.collection('/user').doc(id).get();

    if (snapShot.exists) {
      return 0;
    } else {
      FirebaseFirestore.instance.collection("/user").doc(id).set(data);
      return;
    }
  }
}
