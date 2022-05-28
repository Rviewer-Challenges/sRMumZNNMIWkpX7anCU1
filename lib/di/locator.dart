import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../data/datasource/local/database/app_database.dart';
import '../view/common/manager/theme_manager.dart';
import 'locator.config.dart';

final locator = GetIt.instance;

@injectableInit
void setUpLocator() {
  _init();
  $initGetIt(locator);
}

GlobalKey<NavigatorState> navigatorKeyBuilder(
    GlobalKey<NavigatorState> navigatorKey) {
  locator.registerLazySingleton<GlobalKey<NavigatorState>>(() => navigatorKey);

  return navigatorKey;
}

void initScreenUtil(BuildContext context) {
  if (!locator.isRegistered<ThemeManager>()) {
    ScreenUtil.init(context);
    locator.registerSingleton(ThemeManager());
  }
}

void _init() {
  // locator.registerSingleton(() => ThemeManager());
  _openStore();
}

void _openStore() => AppDatabase.appDatabase.open();
