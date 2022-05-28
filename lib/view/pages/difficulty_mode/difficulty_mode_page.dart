import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:found_pairs/view/common/manager/theme_manager.dart';

import '../../../di/locator.dart';
import '../../../core/common/palette.dart';
import '../../common/widgets/custom_button.dart';
import '../../utils/game_utils/difficulty_mode_type.dart';
import 'difficulty_mode_manager.dart';

class DifficultyModePage extends StatefulWidget {
  const DifficultyModePage({Key? key}) : super(key: key);

  @override
  State<DifficultyModePage> createState() => _DifficultyModePageState();
}

class _DifficultyModePageState extends State<DifficultyModePage> {
  final DifficultyModeManager _manager = locator<DifficultyModeManager>();
  final ThemeManager _themeManager = locator<ThemeManager>();

  @override
  void dispose() {
    _manager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(height: MediaQuery.of(context).size.height * .025);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Difficulty mode'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              _DifficultyItem(
                DifficultyModeType.easy,
                _manager,
                isDark: _themeManager.isDark.value,
              ),
              spacer,
              _DifficultyItem(
                DifficultyModeType.medium,
                _manager,
                isDark: _themeManager.isDark.value,
              ),
              spacer,
              _DifficultyItem(
                DifficultyModeType.hard,
                _manager,
                isDark: _themeManager.isDark.value,
              ),
              spacer,
              _DifficultyItem(
                DifficultyModeType.custom,
                _manager,
                isDark: _themeManager.isDark.value,
              ),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: _manager.difficultySelected,
                builder: (_, DifficultyModeType type, __) => Text(
                  type.description,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              const Spacer(),
              ValueListenableBuilder(
                valueListenable: _manager.difficultySelected,
                builder: (_, DifficultyModeType type, __) => CustomButton(
                  type == DifficultyModeType.custom ? 'Custom game' : 'Play!',
                  _manager.exitFromPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyItem extends StatelessWidget {
  const _DifficultyItem(
    this.type,
    this.manager, {
    Key? key,
    required this.isDark,
  }) : super(key: key);

  final DifficultyModeType type;
  final DifficultyModeManager manager;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: manager.difficultySelected,
      builder: (_, DifficultyModeType typeSelected, __) => GestureDetector(
        onTap: () => manager.selectDifficulty(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: (typeSelected.id == type.id) ? 1.0 : 2.0,
              color: (typeSelected.id == type.id)
                  ? isDark
                      ? type.darkColor ?? type.lightColor
                      : type.lightColor
                  : isDark
                      ? Palette.darkItem
                      : Palette.lightItem,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: typeSelected.id == type.id,
                child: Image.asset(type.difficultyIcon),
              ),
              Text(
                type.text,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight:
                      (typeSelected.id == type.id) ? FontWeight.w300 : null,
                  color: (typeSelected.id == type.id)
                      ? isDark
                          ? type.darkColor ?? type.lightColor
                          : type.lightColor
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
