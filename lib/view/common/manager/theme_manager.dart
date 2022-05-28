import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/custom_notifiers.dart';
import '../../../core/common/palette.dart';
import '../../../di/locator.dart';
import '../../../domain/use_case/settings_use_case.dart';

class ThemeManager {
  ThemeData _getTheme(bool isDark) => ThemeData(
        primaryColor: Palette.red,
        brightness: isDark ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w300,
            color: Palette.red,
          ),
          centerTitle: true,
          color: Palette.transparent,
          elevation: .0,
          iconTheme: const IconThemeData(color: Palette.red),
        ),
        iconTheme: IconThemeData(
          color: isDark ? Palette.darkItem : Palette.lightItem,
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 16.sp),
          bodyText2: TextStyle(fontSize: 16.sp),
        ).apply(
          bodyColor: isDark ? Palette.darkItem : Palette.lightItem,
          displayColor: isDark ? Palette.darkItem : Palette.lightItem,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Palette.red),
          ),
          focusColor: Palette.red,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        dividerColor: isDark ? Palette.darkItem : Palette.lightItem,
        listTileTheme: ListTileThemeData(
          textColor: isDark ? Palette.darkItem : Palette.lightItem,
        ),
        cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
              fontSize: 16.sp,
              color: isDark ? Palette.darkItem : Palette.lightItem,
            ),
            pickerTextStyle: TextStyle(
              fontSize: 16.sp,
              color: isDark ? Palette.darkItem : Palette.lightItem,
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Palette.purple,
          contentTextStyle: TextStyle(
            fontSize: 16.sp,
            color: Palette.white,
            fontWeight: FontWeight.w300,
          ),
        ),
      );

  final GetThemeModeUseCase _getThemeModeUseCase =
      locator<GetThemeModeUseCase>();

  final CustomValueNotifier<ThemeData?> _themeData = CustomValueNotifier(null);
  CustomValueNotifier<ThemeData?> get themeData => _themeData;

  final CustomValueNotifier<bool> _isDark = CustomValueNotifier(false);
  CustomValueNotifier<bool> get isDark => _isDark;

  ThemeManager() {
    _themeData.value = _getTheme(false);
    _getThemeModeUseCase.getThemeMode().then(setThemeMode);
  }

  void setThemeMode(bool isDark) {
    _themeData.value = _getTheme(isDark);
    _isDark.value = isDark;
  }

  void dispose() {
    _themeData.dispose();
    _isDark.dispose();
  }
}
