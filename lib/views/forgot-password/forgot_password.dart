// Flutter
import 'package:flutter/material.dart';
import 'package:dogo_final_app/theme/theme.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_rounded_text.dart';
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
        formKey: formKey,
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
                    'Avez-vous oublié le mot de passe ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Saisissez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 15,
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
                          child: Text("Quel est votre email ?"),
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
