import 'package:flutter/material.dart';

import '../../../core/common/palette.dart';
import '../../../di/locator.dart';
import '../../common/style/pictures.dart';
import 'splash_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _manager = locator<SplashManager>();

  bool _hasNavigated = false;

  @override
  void initState() {
    _manager.initAudioService();

    super.initState();
  }

  @override
  void dispose() {
    _manager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.splash,
      body: FutureBuilder(
        future: Future.delayed(
          const Duration(seconds: 4),
          () {
            if (!_hasNavigated) {
              _hasNavigated = true;
              _manager.navigateToHome();
            }
          },
        ),
        builder: (_, __) => Center(
          child: Image.asset(
            Pictures.introGif,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
