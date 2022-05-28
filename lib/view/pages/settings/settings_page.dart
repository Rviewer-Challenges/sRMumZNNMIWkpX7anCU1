import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/palette.dart';
import '../../../di/locator.dart';
import 'settings_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsManager _manager = locator<SettingsManager>();

  @override
  void dispose() {
    _manager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(height: MediaQuery.of(context).size.height * .03);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacer,
                _SettingSwitchItem(
                  'Sfx sound state',
                  _manager.settingsService.isSfxEnabled,
                  onChanged: _manager.setSfxEnabled,
                  settingDescription:
                      'Enable or disable the secondary sounds effects for the game',
                ),
                spacer,
                _SettingSliderItem(
                  'Sfx volume',
                  _manager.settingsService.sfxVolume,
                  onChanged: _manager.setSfxVolume,
                ),
                spacer,
                _SettingSwitchItem(
                  'Music sound state',
                  _manager.settingsService.isMusicEnabled,
                  onChanged: _manager.setMusicEnabled,
                  settingDescription: 'Enable or disable the music',
                ),
                spacer,
                _SettingSliderItem(
                  'Music volume',
                  _manager.settingsService.musicVolume,
                  onChanged: _manager.setMusicVolume,
                ),
                spacer,
                const Divider(),
                spacer,
                _SettingSwitchItem(
                  'Dark Mode',
                  _manager.themeManager.isDark,
                  onChanged: _manager.setThemeMode,
                ),
                spacer,
                const Divider(),
                spacer,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingSwitchItem extends StatelessWidget {
  const _SettingSwitchItem(
    String setting,
    ValueListenable<bool> valueListenable, {
    Key? key,
    required Function onChanged,
    String? settingDescription,
  })  : _setting = setting,
        _valueListenable = valueListenable,
        _onChanged = onChanged,
        _settingDescription = settingDescription,
        super(key: key);

  final String _setting;
  final ValueListenable<bool> _valueListenable;
  final Function _onChanged;
  final String? _settingDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _setting,
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _valueListenable,
              builder: (_, bool isActivated, __) => Switch.adaptive(
                value: isActivated,
                onChanged: (newValue) => _onChanged.call(newValue),
                activeColor: Palette.red,
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        Visibility(
          visible: _settingDescription != null,
          maintainSize: false,
          child: Text(
            _settingDescription ?? '',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingSliderItem extends StatelessWidget {
  const _SettingSliderItem(
    String setting,
    ValueListenable<double> valueListenable, {
    Key? key,
    required Function onChanged,
  })  : _setting = setting,
        _valueListenable = valueListenable,
        _onChanged = onChanged,
        super(key: key);

  final String _setting;
  final ValueListenable<double> _valueListenable;
  final Function _onChanged;

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(height: MediaQuery.of(context).size.height * .01);

    return ValueListenableBuilder(
      valueListenable: _valueListenable,
      builder: (_, double value, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .03),
          Text(
            _setting,
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
          spacer,
          Slider.adaptive(
            min: 0,
            max: 100,
            divisions: 100,
            value: value * 100,
            activeColor: Palette.red,
            onChanged: (newValue) =>
                _onChanged.call(newValue.roundToDouble() / 100),
          ),
          spacer,
          Text(
            (value * 100).toInt().toString(),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
