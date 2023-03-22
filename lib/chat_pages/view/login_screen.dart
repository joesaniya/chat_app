import 'package:chat_demo/theme/constant.dart';
import 'package:chat_demo/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ThemeData theme;
  late LoginController controller;
  late OutlineInputBorder outlineInputBorder;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(LoginController());
    outlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(Constant.containerRadius.xs)),
      borderSide: const BorderSide(
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<LoginController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            body: Padding(
              padding: FxSpacing.fromLTRB(
                  20, FxSpacing.safeAreaTop(context) + 40, 20, 0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Image.asset("assets/chat2.png"),
                      // Image.asset("assets/chat1.png"),
                      FxSpacing.height(60),
                      FxText.titleLarge(
                        "Login to your account",
                        fontWeight: 700,
                      ),
                      FxSpacing.height(40),
                      loginForm(),
                      // FxSpacing.height(10),
                      // forgotPasswordBtn(),
                      FxSpacing.height(30),
                      loginBtn(),
                      FxSpacing.height(10),
                      registerBtn(),
                      FxSpacing.height(20),
                      const Divider(),
                      FxSpacing.height(20),
                      // google(),
                      // FxSpacing.height(20),
                      // facebook(),
                      // FxSpacing.height(20),
                      // apple()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget loginForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [emailField(), FxSpacing.height(20), passwordField()],
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Email Address",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      onChanged: (val) {
        setState(() {
          controller.email = val;
        });
      },

      // check tha validation
      validator: (val) {
        return RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val!)
            ? null
            : "Please enter a valid email";
      },

      // controller: controller.emailController,
      // validator: controller.validateEmail,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget passwordField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      obscureText: _obscureText,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          suffixIconColor: Colors.grey,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            color: Colors.grey,
            onPressed: _toggle,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Password",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      // controller: controller.passwordController,
      // validator: controller.validatePassword,
      validator: (val) {
        if (val!.length < 6) {
          return "Password must be at least 6 characters";
        } else {
          return null;
        }
      },
      onChanged: (val) {
        setState(() {
          controller.password = val;
        });
      },
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget loginBtn() {
    return FxButton.block(
      onPressed: () {
        controller.login();
      },
      borderRadiusAll: Constant.buttonRadius.xs,
      elevation: 0,
      child: FxText.labelLarge(
        "Login to your account",
        fontWeight: 700,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget registerBtn() {
    return FxButton.text(
      onPressed: () {
        controller.goToRegisterScreen();
      },
      child: FxText.bodySmall(
        "Don't have an account?",
        fontWeight: 600,
        xMuted: true,
      ),
    );
  }

  Widget forgotPasswordBtn() {
    return Align(
      alignment: Alignment.centerRight,
      child: FxButton.text(
        padding: FxSpacing.zero,
        onPressed: () {
          controller.goToForgotPasswordScreen();
        },
        child: FxText.bodySmall(
          "Forgot password?",
          fontWeight: 600,
          xMuted: true,
        ),
      ),
    );
  }

  Widget google() {
    return FxButton.block(
      elevation: 0,
      padding: FxSpacing.y(12),
      backgroundColor: theme.cardTheme.color,
      borderRadiusAll: Constant.buttonRadius.xs,
      onPressed: () {
        // controller.googlein2();
        controller.loggoogle();
        // controller.signInWithGoogle();
        // controller.googleSignIn();
        // controller.signUpWithGoogle();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: 20,
            width: 20,
            color: theme.colorScheme.primary,
            image: const AssetImage(
              'assets/google.png',
            ),
          ),
          FxSpacing.width(12),
          FxText.labelLarge(
            "Continue with Google",
            fontWeight: 700,
          ),
        ],
      ),
    );
  }

  Widget facebook() {
    return FxButton.block(
      elevation: 0,
      padding: FxSpacing.y(12),
      backgroundColor: theme.cardTheme.color,
      borderRadiusAll: Constant.buttonRadius.xs,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: 20,
            width: 20,
            color: theme.colorScheme.primary,
            image: const AssetImage('assets/facebook.png'),
          ),
          FxSpacing.width(12),
          FxText.labelLarge(
            "Continue with Facebook",
            fontWeight: 700,
          ),
        ],
      ),
    );
  }

  Widget apple() {
    return FxButton.block(
      elevation: 0,
      padding: FxSpacing.y(12),
      backgroundColor: theme.cardTheme.color,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: 20,
            width: 20,
            color: theme.colorScheme.primary,
            image: const AssetImage('assets/apple.png'),
          ),
          FxSpacing.width(12),
          FxText.labelLarge(
            "Continue with Apple",
            fontWeight: 700,
          ),
        ],
      ),
    );
  }
}
