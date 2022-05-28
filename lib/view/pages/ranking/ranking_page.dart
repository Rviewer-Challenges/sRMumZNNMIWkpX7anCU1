import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/palette.dart';
import '../../../core/common/status.dart';
import '../../../di/locator.dart';
import '../../../domain/model/score_model.dart';
import '../../common/widgets/custom_button.dart';
import '../../utils/time_utils.dart';
import 'ranking_manager.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final RankingManager _manager = locator<RankingManager>();

  @override
  void initState() {
    _manager.getRanking();

    super.initState();
  }

  @override
  void dispose() {
    _manager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _manager.navigateToHome();
        return false;
      },
      child: WillPopScope(
        onWillPop: () async {
          _manager.navigateToHome();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Ranking'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Expanded(child: _Content(manager: _manager)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, .0, 16.0, 16.0),
                    child: CustomButton(
                      'Close',
                      _manager.navigateToHome,
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

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required RankingManager manager,
  })  : _manager = manager,
        super(key: key);

  final RankingManager _manager;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Status>(
      valueListenable: _manager.status,
      builder: (_, Status status, __) =>
          ValueListenableBuilder<List<ScoreModel>>(
        valueListenable: _manager.ranking,
        builder: (_, List<ScoreModel> ranking, __) => (status == Status.loading)
            ? const Center(child: CircularProgressIndicator())
            : ranking.isNotEmpty
                ? _RankingList(ranking)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_esports_outlined,
                        size: MediaQuery.of(context).size.width * .5,
                      ),
                      const Text(
                        'Play and save your score to get a place in the ranking!',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _RankingList extends StatelessWidget {
  const _RankingList(
    List<ScoreModel> ranking, {
    Key? key,
  })  : _ranking = ranking,
        super(key: key);

  final List<ScoreModel> _ranking;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      shrinkWrap: true,
      itemCount: _ranking.length,
      separatorBuilder: (_, __) => const Divider(color: Palette.red),
      itemBuilder: (_, index) => _RankingItem(index + 1, _ranking[index]),
    );
  }
}

class _RankingItem extends StatelessWidget {
  const _RankingItem(int index, ScoreModel score, {Key? key})
      : _index = index,
        _score = score,
        super(key: key);

  final int _index;
  final ScoreModel _score;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_index.toString()}. ',
            style: TextStyle(fontSize: 16.sp),
          ),
          Image.asset(_score.difficultyIcon),
        ],
      ),
      title: Flexible(
        child: Text(
          _score.name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      trailing: Text(
        TimeUtils.formatDuration(Duration(seconds: _score.timeInSeconds)),
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
