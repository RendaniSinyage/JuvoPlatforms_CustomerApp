import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import '../game_bloc/game_bloc.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final score = state.board?.score ?? 0;
        final best = state.board?.best ?? 0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Score(
              label: AppHelpers.getTranslation(TrKeys.score),
              score: '$score',
            ),
            16.horizontalSpace,
            Score(
                label: AppHelpers.getTranslation(TrKeys.best),
                score: '$best',
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0)),
          ],
        );
      },
    );
  }
}

class Score extends StatelessWidget {
  const Score({
    super.key,
    required this.label,
    required this.score,
    this.padding,
  });

  final String label;
  final String score;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: AppStyle.iconButtonBack, borderRadius: BorderRadius.circular(8.0)),
      child: Column(children: [
        Text(
          label.toUpperCase(),
          style: AppStyle.interNormal(color: AppStyle.black),
        ),
        Text(
          score,
          style: AppStyle.interSemi(color: AppStyle.black),
        )
      ]),
    );
  }
}
