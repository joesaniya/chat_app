import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../../helper/helper_function.dart';
import '../../pages/home_page.dart';
import '../../service/auth_service.dart';
import '../../widgets/widgets.dart';
import '../view/login_screen.dart';

class RegisterController extends FxController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool enable = false;

  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    save = false;
  }

  String? validateName(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter  name";
    }
    return null;
  }

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

  void toggle() {
    enable = !enable;
    update();
  }

  void goToLoginScreen() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  bool _isLoading = false;

  register() async {
    if (formKey.currentState!.validate()) {
      _isLoading = true;

      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePage());
          log('success');
        } else {
          showSnackbar(context, Colors.red, value);

          _isLoading = false;
        }
      });
    }
  }

  @override
  String getTag() {
    return "register_controller";
  }
}
