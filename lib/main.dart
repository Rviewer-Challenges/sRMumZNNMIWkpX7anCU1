import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'di/locator.dart';
import 'view/common/app_lifecycle_observer.dart';
import 'view/common/manager/theme_manager.dart';
import 'view/view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  setUpLocator();
  await ScreenUtil.ensureScreenSize();
  final _navigatorKey = navigatorKeyBuilder(GlobalKey<NavigatorState>());

  runApp(MyApp(_navigatorKey));
}

class MyApp extends StatelessWidget {
  const MyApp(
    this._navigatorKey, {
    Key? key,
  }) : super(key: key);

  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  Widget build(BuildContext context) {
    initScreenUtil(context);

    return AppLifecycleObserver(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => ValueListenableBuilder(
          valueListenable: locator<ThemeManager>().themeData,
          builder: (_, ThemeData? themeMode, __) => MaterialApp(
            title: 'Material App',
            navigatorKey: _navigatorKey,
            theme: themeMode,
            onGenerateRoute: View.getRoutes,
            initialRoute: View.getInitialRoute(),
          ),
        ),
      ),
    );
  }
}
