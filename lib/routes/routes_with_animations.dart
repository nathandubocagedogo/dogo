import 'package:dogo_final_app/animations/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:dogo_final_app/views/welcome/welcome.dart';
import 'package:dogo_final_app/views/login/login_home.dart';
import 'package:dogo_final_app/views/login/login.dart';
import 'package:dogo_final_app/views/register/register.dart';
import 'package:dogo_final_app/views/forgot-password/forgot_password.dart';
import 'package:dogo_final_app/views/home/home.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  WidgetBuilder builder;

  switch (settings.name) {
    case '/':
    case '/welcome':
      builder = (BuildContext context) => const WelcomeView();
      break;
    case '/login-home':
      builder = (BuildContext context) => const LoginHomeView();
      break;
    case '/login':
      builder = (BuildContext context) => const LoginView();
      break;
    case '/register':
      builder = (BuildContext context) => const RegisterView();
      break;
    case '/forgot-password':
      builder = (BuildContext context) => const ForgotPassewordView();
      break;
    case '/home':
      builder = (BuildContext context) => const HomeView();
    case '/account':
      builder = (BuildContext context) => const Placeholder();
    default:
      builder = (BuildContext context) => const WelcomeView();
  }

  return CustomPageRoute(builder: builder);
}
