import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/palette.dart';
import '../../../core/common/status.dart';
import '../../../di/locator.dart';
import '../../common/widgets/custom_button.dart';
import '../../utils/time_utils.dart';
import 'score_arguments.dart';
import 'score_manager.dart';

class ScorePage extends StatefulWidget {
  const ScorePage(this.scoreArguments, {Key? key}) : super(key: key);

  final ScoreArguments scoreArguments;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final ScoreManager _manager = locator<ScoreManager>();

  final TextEditingController _controller = TextEditingController();

  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  void dispose() {
    _manager.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(height: MediaQuery.of(context).size.height * .06);

    return WillPopScope(
      onWillPop: () async {
        _manager.navigateToHome();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ValueListenableBuilder<Status>(
              valueListenable: _manager.status,
              builder: (_, Status status, __) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ScoreText(widget.scoreArguments.timeInSeconds),
                  spacer,
                  status == Status.loading
                      ? const Center(child: CircularProgressIndicator())
                      : _ScoreNameForm(
                          _formKey,
                          _manager,
                          widget.scoreArguments,
                          _controller,
                        ),
                  spacer,
                  Visibility(
                    visible: status != Status.loading,
                    child: InkWell(
                      onTap: () => _manager.navigateToHome(),
                      child: const Text(
                        'Continue without save',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Palette.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreText extends StatelessWidget {
  const _ScoreText(
    int time, {
    Key? key,
  })  : _time = time,
        super(key: key);

  final int _time;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'You have finished the quiz with\na time of: ',
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .03),
        Text(
          TimeUtils.formatDuration(Duration(seconds: _time)),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ScoreNameForm extends StatelessWidget {
  const _ScoreNameForm(
    GlobalKey<FormState> formKey,
    ScoreManager manager,
    ScoreArguments arguments,
    TextEditingController controller, {
    Key? key,
  })  : _formKey = formKey,
        _manager = manager,
        _scoreArguments = arguments,
        _controller = controller,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final ScoreManager _manager;
  final ScoreArguments _scoreArguments;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(height: MediaQuery.of(context).size.height * .03);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'You want to save your time?',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          spacer,
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter your name...'),
            validator: (value) => ((value?.length ?? 0) <= 3)
                ? 'The name must have more than 3 characters'
                : null,
          ),
          spacer,
          CustomButton(
            'Save time',
            () => _saveScore(_scoreArguments),
          ),
        ],
      ),
    );
  }

  // Functions
  void _saveScore(ScoreArguments arguments) {
    if (_formKey.currentState!.validate()) {
      _manager.saveScore(
        _controller.value.text,
        arguments.difficultyId,
        arguments.score,
        arguments.timeInSeconds,
      );
    }
  }
}
