// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dogo_final_app/theme/theme.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_rounded_icon_text.dart';
import 'package:dogo_final_app/components/buttons/button_back.dart';

// Services
import 'package:dogo_final_app/services/auth.dart';

// Utilities
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginHomeView extends StatefulWidget {
  const LoginHomeView({super.key});

  @override
  State<LoginHomeView> createState() => _LoginHomeViewState();
}

class _LoginHomeViewState extends State<LoginHomeView> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const ButtonBack(
          icon: Icons.clear_rounded,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.9,
              child: Column(
                children: [
                  const Text(
                    'Connecte toi ou \n inscris-toi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Connecte-toi afin de ne pas perdre les balades que tu as enregistrées et les groupes auxquelles tu appartiens.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ButtonRoundedIconText(
                    content: "Continuer avec Google",
                    icon: FontAwesomeIcons.google,
                    iconSize: 16,
                    gap: 18,
                    callback: () async {
                      await authService.signInWithGoogle(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  ButtonRoundedIconText(
                    content: "Continuer avec Apple",
                    icon: FontAwesomeIcons.apple,
                    iconSize: 20,
                    gap: 18,
                    callback: () async {
                      await authService.signInWithApple(context);
                    },
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
                    content: "S'inscrire par e-mail",
                    icon: FontAwesomeIcons.solidEnvelope,
                    iconSize: 20,
                    gap: 18,
                    callback: () => Navigator.pushNamed(context, '/register'),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'As-tu déjà un compte ? ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: 'Connexion',
                          style: TextStyle(
                            color: themeData.primaryColor,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Navigator.pushNamed(context, '/login'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                      children: [
                        const TextSpan(
                          text: 'En créant un compte, tu acceptes la ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextSpan(
                          text: 'politique de confidentialité',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                Navigator.pushNamed(context, '/privacy-policy'),
                        ),
                        const TextSpan(
                          text: ' de Dogo.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
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
