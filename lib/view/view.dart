import 'package:flutter/material.dart';

import 'utils/router.dart';

abstract class View {
  /// Routing
  static Route<dynamic> getRoutes(RouteSettings settings) =>
      AppRouter.generateRoute(settings);

  static String getInitialRoute() => AppRouter.splashRoute;
}
