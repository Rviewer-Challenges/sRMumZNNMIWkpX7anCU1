import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/palette.dart';
import '../../../../di/locator.dart';
import '../../../common/widgets/custom_button.dart';
import 'custom_mode_manager.dart';

class CustomModePage extends StatefulWidget {
  const CustomModePage({Key? key}) : super(key: key);

  @override
  State<CustomModePage> createState() => _CustomModePageState();
}

class _CustomModePageState extends State<CustomModePage> {
  final CustomModeManager _manager = locator<CustomModeManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Customize game'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RadioNumber(_manager),
              SizedBox(height: MediaQuery.of(context).size.height * .03),
              _CustomTimePicker(_manager),
              const Spacer(),
              CustomButton('Play!', _onPlayTapped),
            ],
          ),
        ),
      ),
    );
  }

  // Funcitons
  void _onPlayTapped() {
    _validateSelectedTime()
        ? _manager.navigateToBoard()
        : _showInvalidSelectedTime();
  }

  bool _validateSelectedTime() =>
      _manager.selectedMinutes.value != 0 ||
      _manager.selectedSeconds.value != 0;

  void _showInvalidSelectedTime() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The selected time must be different than 00:00'),
        ),
      );
}

class _CustomTimePicker extends StatelessWidget {
  const _CustomTimePicker(
    this.manager, {
    Key? key,
  }) : super(key: key);

  final CustomModeManager manager;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time to catch them all:',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .01),
        SizedBox(
          height: MediaQuery.of(context).size.height * .15,
          child: Row(
            children: [
              Flexible(child: _Picker(2, manager.selectMinutes)),
              const Text(':'),
              Flexible(child: _Picker(60, manager.selectSeconds)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Picker extends StatelessWidget {
  const _Picker(
    this.length,
    this.onChanged, {
    Key? key,
  }) : super(key: key);

  final int length;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoPicker(
        itemExtent: MediaQuery.of(context).size.height * .055,
        children: List.generate(
          length,
          (index) => _PickerItem(index),
        ),
        onSelectedItemChanged: (value) => onChanged.call(value),
      ),
    );
  }
}

class _PickerItem extends StatelessWidget {
  const _PickerItem(
    this.value, {
    Key? key,
  }) : super(key: key);

  final int value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value.toString().padLeft(2, '0'),
      style: TextStyle(fontSize: 32.sp),
    );
  }
}

class _RadioNumber extends StatelessWidget {
  const _RadioNumber(
    this.manager, {
    Key? key,
  }) : super(key: key);

  final CustomModeManager manager;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Pokemon to catch: ',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        SizedBox(height: height * .01),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: manager.numberOfPairsList.length,
          itemBuilder: (_, index) => _RadioItem(
            manager.numberOfPairsList[index],
            manager,
          ),
        ),
      ],
    );
  }
}

class _RadioItem extends StatelessWidget {
  const _RadioItem(
    this.value,
    this.manager, {
    Key? key,
  }) : super(key: key);

  final int value;
  final CustomModeManager manager;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(value.toString()),
      leading: ValueListenableBuilder(
        valueListenable: manager.selectedNumberOfPairs,
        builder: (_, int selectedValue, __) => Radio(
          value: value,
          groupValue: selectedValue,
          onChanged: (_) => manager.selectNumberOfPairs(value),
          activeColor: Palette.red,
        ),
      ),
    );
  }
}
