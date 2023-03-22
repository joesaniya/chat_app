import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:chat_demo/service/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../helper/helper_function.dart';
import '../../pages/home_page.dart';
import '../../service/database_service.dart';
import '../../widgets/widgets.dart';
import '../view/register_screen.dart';

class LoginController extends FxController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = true;

  @override
  void initState() {
    super.initState();
    save = false;
    emailController = TextEditingController(text: 'flutkit@coderthemes.com');
    passwordController = TextEditingController(text: 'password');
  }

  String email = "";
  String password = "";

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (!FxStringValidator.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    } else if (!FxStringValidator.validateStringRange(text, 6, 10)) {
      return "Password must be between 6 to 10";
    }
    return null;
  }

  void goToRegisterScreen() {
    log('dont have clicked');
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  googlesign() async {}
  void goToForgotPasswordScreen() {
    // Navigator.of(context, rootNavigator: true).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) => ForgotPasswordScreen(),
    //   ),
    // );
  }

  Future<void> signUpWithGoogle(
      // BuildContext context,
      // bool mounted,
      ) async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        //
      });
      if (mounted) return;
      log('message sucess');
    } on Exception {
      if (mounted) return;
      log('error');
      // InfoBox.show(context, InfoBox.success, e.toString());
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  AuthService authService = AuthService(); //_auth
  login() async {
    if (formKey.currentState!.validate()) {
      _isLoading = true;
      update();
      await authService
          .loginWithUserNameandPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          // saving the values to our shared preferences
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, const HomePage());
          // log('name sucess');
        } else {
          showSnackbar(context, Colors.indigo, value);

          _isLoading = false;
          update();
        }
      });
    }
  }

  loggoogle() async {
    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleuser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    log('name:${userCredential.user?.displayName}');
    if (userCredential.user != null) {
      log('name:${userCredential.user?.email}');
      QuerySnapshot snapshot = await DatabaseService(uid: googleAuth!.idToken)
          .gettingUserData(email);

      await HelperFunctions.saveUserLoggedInStatus(true);
      await HelperFunctions.saveUserEmailSF(email);
      await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
      nextScreenReplace(context, const HomePage());
    } else {
      Error();
    }
  }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User get user => _auth.currentUser!;

  // Future<bool> signInWithGoogle() async {
  //   bool result = false;
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

  //     UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);
  //     User? user = userCredential.user;

  //     if (user != null) {
  //       if (userCredential.additionalUserInfo!.isNewUser) {
  //         // add the data to fire base
  //         await _firestore.collection('users').doc(user.uid).set({
  //           'username': user.displayName,
  //           'uid': user.uid,
  //           'profilePhoto': user.photoURL,
  //         });
  //       }
  //       result = true;
  //     }
  //     return result;
  //   } catch (e) {
  //     print(e);
  //   }
  //   return result;
  // }

  @override
  String getTag() {
    return "login_controller";
  }
}
