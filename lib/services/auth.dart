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
        FirebaseAuth.instance.currentUser?.uid,
        {
          "name": FirebaseAuth.instance.currentUser?.displayName,
          "email": FirebaseAuth.instance.currentUser?.email,
          "income": [],
          "expenses": [],
          "sources": [],
          "topics":[],
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

  newUser(String? id, Map<String, dynamic> data) async {
    final collection =
        await FirebaseFirestore.instance.collection("users").get();
    if (collection.docs.map((doc) => doc.id).contains(id)) {
      return 0;
    } else {
      FirebaseFirestore.instance.collection("/user").doc(id).set(data);
    }
  }
}
