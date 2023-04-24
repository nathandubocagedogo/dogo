import 'package:flutter/material.dart';

import 'package:dogo_final_app/views/welcome/welcome.dart';
import 'package:dogo_final_app/views/login/login_home.dart';
import 'package:dogo_final_app/views/login/login.dart';
import 'package:dogo_final_app/views/register/register.dart';
import 'package:dogo_final_app/views/forgot-password/forgot_password.dart';

var routes = {
  '/welcome': (context) => const WelcomeView(),
  '/login-home': (context) => const LoginHomeView(),
  '/login': (context) => const LoginView(),
  '/register': (context) => const RegisterView(),
  '/forgot-password': (context) => const ForgotPassewordView(),
  '/home': (context) => const Placeholder(),
  '/account': (context) => const Placeholder(),
};
