import 'package:flutter/material.dart';
import 'package:dogo_final_app/routes/animations.dart';
import 'package:dogo_final_app/views/welcome/welcome.dart';
import 'package:dogo_final_app/views/login/login_home.dart';
import 'package:dogo_final_app/views/login/login.dart';
import 'package:dogo_final_app/views/register/register.dart';
import 'package:dogo_final_app/views/forgot-password/forgot_password.dart';
import 'package:dogo_final_app/views/landing/landing.dart';
import 'package:dogo_final_app/views/home/home.dart';
import 'package:dogo_final_app/views/map/map.dart';
import 'package:dogo_final_app/views/pages/groups/subpages/group_chat.dart';
import 'package:dogo_final_app/views/pages/groups/subpages/group_details.dart';

Route<dynamic> generateRoute(
  RouteSettings settings, {
  AnimationType? animationType,
}) {
  WidgetBuilder builder;
  AnimationType? animationType;

  if (settings.arguments is Map<String, dynamic>) {
    final args = settings.arguments as Map<String, dynamic>;
    animationType = args['animationType'] as AnimationType?;
  }

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
    case '/landing':
      builder = (BuildContext context) => const LandingView();
      break;
    case '/home':
      builder = (BuildContext context) => const HomeView();
      break;
    case '/map':
      builder = (BuildContext context) => const GoogleMapView();
      break;
    case '/group-details':
      builder = (BuildContext context) {
        final arguments = settings.arguments as Map<String, dynamic>;
        final groupId = arguments['groupId'] as String;
        return GroupDetailsPageView(groupId: groupId);
      };
      break;
    case '/group-chat':
      builder = (BuildContext context) {
        final arguments = settings.arguments as Map<String, dynamic>;
        final groupId = arguments['groupId'] as String;
        return GroupChatPageView(groupId: groupId);
      };
      break;
    default:
      builder = (BuildContext context) => const WelcomeView();
  }

  return CustomPageRoute(
    builder: builder,
    animationType: animationType ?? AnimationType.fadeIn,
  );
}
