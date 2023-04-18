import 'package:flutter/material.dart';

import 'package:dogo_final_app/views/welcome/welcome.dart';
import 'package:dogo_final_app/views/login/login.dart';

var routes = {
  '/welcome': (context) => const WelcomeView(),
  '/login': (context) => const LoginView(),
  '/register': (context) => const Placeholder(),
  '/forgot-password': (context) => const Placeholder(),
  '/home': (context) => const Placeholder(),
  '/account': (context) => const Placeholder(),
};
