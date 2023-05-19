// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/theme/theme.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
import 'package:dogo_final_app/components/buttons/button_back.dart';
import 'package:dogo_final_app/components/input/input_rounded_text.dart';

// Services
import 'package:dogo_final_app/services/reset_password.dart';

class ForgotPassewordView extends StatefulWidget {
  const ForgotPassewordView({super.key});

  @override
  State<ForgotPassewordView> createState() => _ForgotPassewordViewState();
}

class _ForgotPassewordViewState extends State<ForgotPassewordView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final ResetPasswordService resetPasswordService = ResetPasswordService();

  bool isLoading = false;

  Future<void> submitForgotPassword() async {
    FocusScope.of(context).unfocus();

    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await resetPasswordService.resetPassword(
        emailController: emailController,
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
          leading: const ButtonBack(),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: screenWidth * 0.90,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  const Text(
                    'As-tu oublié ton mot de passe ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Saisis ton adresse e-mail et nous t\'enverrons un lien pour réinitialiser ton mot de passe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.4,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Quel est ton e-mail ?"),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        InputRoundedText(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          validator: true,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ButtonRoundedText(
                          content: "Réinitialiser le mot de passe",
                          callback: submitForgotPassword,
                          backgroundColor: themeData.primaryColor,
                          textColor: Colors.white,
                          isActive: isLoading,
                        )
                      ],
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
