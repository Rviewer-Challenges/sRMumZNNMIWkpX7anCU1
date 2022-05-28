import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/palette.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
    String text,
    Function onTap, {
    Key? key,
  })  : _text = text,
        _onTap = onTap,
        super(key: key);

  final String _text;
  final Function _onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Palette.red,
        ),
        child: Text(
          _text,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w300,
            color: Palette.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
