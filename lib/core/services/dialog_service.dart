import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../common/palette.dart';
import '../common/play_dialog_types.dart';

@lazySingleton
class DialogService {
  final GlobalKey<NavigatorState> _navigatorKey;

  DialogService(this._navigatorKey);

  BuildContext _getSafeContext() {
    final context = _navigatorKey.currentContext;

    // ignore: prefer_if_null_operators
    return context != null
        ? context
        : throw ('Have you forgot to setup navigation?');
  }

  Future<void> _getDialog({
    required String content,
    required String positiveTextButton,
    required bool isDismissible,
    Function()? positiveButtonAction,
    String? negativeTextButton,
    Function()? negativeButtonAction,
  }) {
    return showDialog(
        context: _getSafeContext(),
        barrierDismissible: isDismissible,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.purple[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            content: Text(content),
            actions: [
              (negativeTextButton != null)
                  ? TextButton(
                      onPressed: negativeButtonAction ??
                          () => _navigatorKey.currentState!.pop(),
                      child: Text(negativeTextButton),
                    )
                  : const SizedBox.shrink(),
              TextButton(
                onPressed: positiveButtonAction ??
                    () => _navigatorKey.currentState!.pop(),
                child: Text(positiveTextButton),
              ),
            ],
          );
        });
  }

  Future<void> showErrorDialog({
    required String content,
    required String textButton,
    Function()? buttonAction,
  }) =>
      _getDialog(
        content: content,
        positiveTextButton: textButton,
        positiveButtonAction: buttonAction,
        isDismissible: false,
      );

  Future<void> showGeneralDialog({
    required String content,
    required String positiveTextButton,
    Function()? positiveButtonAction,
    String? negativeTextButton,
    Function()? negativeButtonAction,
    bool isDismissible = true,
  }) =>
      _getDialog(
        content: content,
        positiveTextButton: positiveTextButton,
        positiveButtonAction: positiveButtonAction,
        negativeTextButton: negativeTextButton,
        negativeButtonAction: negativeButtonAction,
        isDismissible: isDismissible,
      );

  Future<void> showInputDialog({
    required GlobalKey<FormState> formKey,
    required String content,
    required TextEditingController controller,
    required String positiveTextButton,
    Function()? positiveButtonAction,
    String? negativeTextButton,
    Function()? negativeButtonAction,
    bool isDismissible = true,
  }) {
    return showDialog(
      context: _getSafeContext(),
      barrierDismissible: isDismissible,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.purple[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content),
              const SizedBox(height: 20.0),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter an activity name...',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.purple),
                    ),
                    focusColor: Colors.purple,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  cursorColor: Colors.purple,
                  validator: (value) => ((value?.length ?? 0) <= 3)
                      ? 'The name must have more than 3 characters'
                      : null,
                ),
              ),
            ],
          ),
          actions: [
            (negativeTextButton != null)
                ? TextButton(
                    onPressed: negativeButtonAction ??
                        () => _navigatorKey.currentState!.pop(),
                    child: Text(negativeTextButton),
                  )
                : const SizedBox.shrink(),
            TextButton(
              onPressed: () =>
                  positiveButtonAction?.call() ??
                  () => _navigatorKey.currentState!.pop(),
              child: Text(
                positiveTextButton,
                style: const TextStyle(color: Colors.purple),
              ),
            ),
          ],
        );
      },
    );
  }

  // Board page dialogs

  Future<void> showPlayDialog(PlayDialogType type, List<Function> onTaps) {
    final size = MediaQuery.of(_getSafeContext()).size;

    return showDialog(
      context: _getSafeContext(),
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: 16.0,
            ),
            child: (type == PlayDialogType.win)
                ? _buildWinDialog(size, onTaps)
                : (type == PlayDialogType.lose)
                    ? _buildLoseDialog(size, onTaps)
                    : _buildPauseDialog(size, onTaps),
          ),
        );
      },
    );
  }

  Widget _buildWinDialog(Size size, List<Function> onTaps) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'You win!',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * .025),
          const Text(
            'Congratulations, you managed to catch them all!',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * .05),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _CustomButton(
              'Save score',
              () => onTaps[0].call(),
            ),
          ),
          _CustomButton(
            'Go home',
            () => onTaps[1].call(), // _manager.navigateToBoardGame,),
          ),
        ],
      );

  Widget _buildLoseDialog(Size size, List<Function> onTaps) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Time out!',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * .025),
          const Text(
            'Too bad! Time has run out and you haven\'t had time to catch them all.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * .05),
          _CustomButton(
            'Retry',
            () => onTaps[0].call(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _CustomButton(
              'Go home',
              () => onTaps[1].call(),
            ),
          ),
        ],
      );

  Widget _buildPauseDialog(Size size, List<Function> onTaps) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Game paused',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * .05),
          _CustomButton(
            'Resume',
            () => onTaps[0].call(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _CustomButton(
              'Settings',
              () => onTaps[1].call(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _CustomButton(
              'Exit',
              () => onTaps[2].call(),
            ),
          ),
        ],
      );
}

class _CustomButton extends StatelessWidget {
  const _CustomButton(
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
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w300,
            color: Palette.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
