// Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Components
import 'package:dogo_final_app/components/input/input_rounded_icon_text.dart';
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
import 'package:dogo_final_app/components/buttons/button_rounded_icon_text.dart';

// Service
import 'package:dogo_final_app/views/login/services/auth.dart';
import 'package:dogo_final_app/views/login/services/session.dart';
import 'package:flutter/gestures.dart';

// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/theme/theme.dart';
import 'dart:async';

// Utilities
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  StreamSubscription<User?>? authSubscription;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final AuthService authService = AuthService();
  final SessionService sessionService = SessionService();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sessionService.checkIfUserIsLogged(
      firestore: firestore,
      authSubscription: authSubscription,
      context: context,
    );
  }

  @override
  void dispose() {
    super.dispose();
    authSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Connexion',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InputRoundedIconText(
                          controller: emailController,
                          labelText: 'Email',
                          icon: FontAwesomeIcons.solidEnvelope,
                          iconSize: 18,
                        ),
                        const SizedBox(height: 12),
                        InputRoundedIconText(
                          controller: passwordController,
                          labelText: 'Mot de passe',
                          icon: FontAwesomeIcons.lock,
                          iconSize: 18,
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: Text(
                            "Mot de passe oublié ?",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: themeData.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ButtonRoundedText(
                          content: "Se connecter",
                          callback: () async {
                            await authService.signInBasically(
                              formKey: formKey,
                              emailController: emailController,
                              passwordController: passwordController,
                              context: context,
                            );
                          },
                          color: themeData.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Pas encore un Doger ? ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextSpan(
                          text: 'Rejoignez-nous',
                          style: TextStyle(
                            color: themeData.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/register');
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.black38,
                          height: 1.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'OU',
                          style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.black38,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ButtonRoundedIconText(
                    content: "Connexion avec Google",
                    icon: FontAwesomeIcons.google,
                    iconSize: 16,
                    gap: 18,
                    callback: () async {
                      await authService.signInWithGoogle();
                    },
                  ),
                  const SizedBox(height: 12),
                  ButtonRoundedIconText(
                    content: "Connexion avec Apple",
                    icon: FontAwesomeIcons.apple,
                    iconSize: 20,
                    gap: 18,
                    callback: () async {
                      await authService.signInWithApple();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
