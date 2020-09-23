import 'package:appannotation/utils/attributes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithEmail(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser user = result.user;
      return (user != null);
    }catch(e){
      return false;
    }
  }

  Future<FirebaseUser> loginGoogle() async {
    try{
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      if(account == null) return null;
      AuthResult res = await _auth.signInWithCredential
        (GoogleAuthProvider.getCredential(
          idToken: (await account.authentication).idToken,
          accessToken: (await account.authentication).accessToken
      ));
      return res.user;

    }catch(e){
      return null;
    }
  }

  Future<void> logOut() async{
    try{
      _auth.signOut();
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<String> createAccount
      (String _username, String email, String password) async{

    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      return Attributes.success;
    }on PlatformException catch(e){
      return e.message;
    }
  }

  Future<String> forgotPassword(String email) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
      return Attributes.success;
    }on PlatformException catch(e){
      return e.message;
    }
  }

  Future<FirebaseUser> getUser() async{
    try{
      return await _auth.currentUser();
    }on PlatformException catch(e){
      return null;
    }
  }

}
