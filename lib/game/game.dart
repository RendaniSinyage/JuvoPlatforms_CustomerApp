import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import 'components/button.dart';
import 'components/empy_board.dart';
import 'components/score_board.dart';
import 'components/tile_board.dart';
import 'game_bloc/game_bloc.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _moveController = AnimationController(
    duration: const Duration(milliseconds: 100),
    vsync: this,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<GameBloc>().add(const GameEvent.merge());
        _scaleController.forward(from: 0.0);
      }
    });

  late final CurvedAnimation _moveAnimation = CurvedAnimation(
    parent: _moveController,
    curve: Curves.easeInOut,
  );

  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<GameBloc>().add(GameEvent.endRound(
            onSuccess: () {
              _moveController.forward(from: 0.0);
            },
            onFail: () {}));
      }
    });

  late final CurvedAnimation _scaleAnimation = CurvedAnimation(
    parent: _scaleController,
    curve: Curves.easeInOut,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.game),
                    style: AppStyle.interNoSemi(
                        color: AppStyle.black, size: 24),
                  ),
                  32.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const ScoreBoard(),
                              32.horizontalSpace,
                              ButtonWidget(
                                icon: Icons.undo,
                                onPressed: () {
                                  context
                                      .read<GameBloc>()
                                      .add(const GameEvent.undo());
                                },
                              ),
                              16.horizontalSpace,
                              ButtonWidget(
                                icon: Icons.refresh,
                                onPressed: () {
                                  //Restart the game
                                  context
                                      .read<GameBloc>()
                                      .add(const GameEvent.newGame());
                                },
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            KeyboardListener(
              autofocus: true,
              focusNode: FocusNode(),
              onKeyEvent: (KeyEvent event) {
                context.read<GameBloc>().add(GameEvent.onKey(
                    onSuccess: () {
                      _moveController.forward(from: 0.0);
                    },
                    onFail: () {},
                    event: event));
              },
              child: SwipeDetector(
                onSwipe: (direction, offset) {
                  context.read<GameBloc>().add(GameEvent.move(
                      onSuccess: () {
                        _moveController.forward(from: 0.0);
                      },
                      onFail: () {},
                      direction: direction));
                },
                child: Stack(
                  children: [
                    const EmptyBoardWidget(),
                    TileBoardWidget(
                        moveAnimation: _moveAnimation,
                        scaleAnimation: _scaleAnimation)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: const PopButton(),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      context.read<GameBloc>().add(const GameEvent.save());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _moveAnimation.dispose();
    _scaleAnimation.dispose();
    _moveController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}
