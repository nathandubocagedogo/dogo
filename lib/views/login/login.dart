// Services
import 'package:dogo_final_app/services/auth.dart';

// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/theme/theme.dart';

// Components
import 'package:dogo_final_app/components/input/input_rounded_text.dart';
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> submitLogin() async {
    FocusScope.of(context).unfocus();

    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService.signInBasically(
        emailController: emailController,
        passwordController: passwordController,
        context: context,
      );
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: screenWidth * 0.85,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  const Text(
                    'Connexion',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("E-mail"),
                        const SizedBox(height: 12),
                        InputRoundedText(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          validator: true,
                        ),
                        const SizedBox(height: 30),
                        const Text("Mot de passe"),
                        const SizedBox(height: 12),
                        InputRoundedText(
                          controller: passwordController,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          validator: true,
                        ),
                        const SizedBox(height: 30),
                        ButtonRoundedText(
                          content: "Connexion",
                          callback: submitLogin,
                          backgroundColor: themeData.primaryColor,
                          textColor: Colors.white,
                          isActive: isLoading,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: const Text(
                      'Avez-vous oublié le mot de passe ?',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
