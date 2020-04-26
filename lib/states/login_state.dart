import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences _preferences;

  bool _loggedIn = false;
  bool _loading = true;
  FirebaseUser _user;

  LoginState() {
    loginState();
  }

  bool isLoggedIn() => _loggedIn;

  bool isLoading() => _loading;

  FirebaseUser currentUser() => _user;

  //login
  void login() async {
    _loading = true;
    notifyListeners();
    _user = await _handleSignIn();

    //Verificando se o usuário existe
    _loading = false;
    if (_user != null) {
      _preferences.setBool('isLoggedIn', true);
      _loggedIn = true;
      notifyListeners();
    } else {
      _loggedIn = false;
      notifyListeners();
    }
  }

  //logout
  void logout() {
    _preferences.clear();
    _googleSignIn.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential));
    print("signed in " + user.displayName);
    return user;
  }

  void loginState() async {
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey('isLoggedIn')) {
      _user = await _auth.currentUser();
      _loggedIn = _user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
  }
}
