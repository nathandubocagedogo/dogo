// Flutter
import 'package:flutter/material.dart';

enum AnimationType { fadeIn, slideRight, slideLeft, slideBottom, slideTop }

class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final AnimationType animationType;

  CustomPageRoute(
      {required WidgetBuilder builder,
      this.animationType = AnimationType.fadeIn})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            switch (animationType) {
              case AnimationType.fadeIn:
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              case AnimationType.slideRight:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(
                        0.0,
                        0.5,
                        curve: Curves.linear,
                      ),
                    ),
                  ),
                  child: child,
                );
              case AnimationType.slideLeft:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(
                        0.0,
                        0.5,
                        curve: Curves.linear,
                      ),
                    ),
                  ),
                  child: child,
                );
              case AnimationType.slideBottom:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1), // Commencez à partir du bas
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );

              case AnimationType.slideTop:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1), // Commencez à partir du haut
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              default:
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
            }
          },
        );
}
