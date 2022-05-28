import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../pages/board/board_arguments.dart';
import '../pages/board/board_page.dart';
import '../pages/difficulty_mode/custom_mode/custom_mode_page.dart';
import '../pages/difficulty_mode/difficulty_mode_page.dart';
import '../pages/home/home_page.dart';
import '../pages/ranking/ranking_page.dart';
import '../pages/score/score_arguments.dart';
import '../pages/score/score_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/settings/settings_page.dart';

abstract class AppRouter {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String rankingRoute = '/ranking';
  static const String settingsRoute = '/settings';
  static const String difficultyModeRoute = '/difficulty_mode';
  static const String customModeRoute = '/custom_mode';
  static const String boardRoute = '/board';
  static const String scoreRoute = '/score';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return _fadeRoute(const SplashPage(), splashRoute);

      case homeRoute:
        return _fadeRoute(const HomePage(), homeRoute);

      case rankingRoute:
        return _fadeRoute(const RankingPage(), rankingRoute);

      case settingsRoute:
        return _fadeRoute(const SettingsPage(), settingsRoute);

      case difficultyModeRoute:
        return _fadeRoute(const DifficultyModePage(), difficultyModeRoute);

      case customModeRoute:
        return _fadeRoute(const CustomModePage(), customModeRoute);

      case boardRoute:
        return _fadeRoute(
          BoardPage(settings.arguments as BoardArguments),
          boardRoute,
        );

      case scoreRoute:
        return _fadeRoute(
          ScorePage(settings.arguments as ScoreArguments),
          scoreRoute,
        );

      default:
        return _fadeRoute(const HomePage(), homeRoute);
    }
  }

  static PageRoute _fadeRoute(Widget child, String routeName) =>
      PageRouteBuilder(
        settings: RouteSettings(name: routeName),
        pageBuilder: (_, __, ___) => child,
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (_, animation, __, ___) => Platform.isAndroid
            ? FadeTransition(
                opacity: animation,
                child: child,
              )
            : CupertinoPageTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: __,
                child: child,
                linearTransition: true,
              ),
      );
}
