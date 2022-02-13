// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:math_test/game/bloc/models/result.dart';
import 'package:math_test/game/view/game_page.dart';
import 'package:math_test/home/widgets.dart';
import 'package:math_test/scores/cubit/scored_bloc.dart';
import 'package:math_test/settings/cubit/app_settings_cubit.dart';
import 'package:math_test/settings/view/settings_view.dart';
import 'package:math_test/widgets/custom_theme.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  static void openSettings(BuildContext context) {
    Navigator.of(context).push(SettingsPage.route(
        context.read<AppSettingsCubit>(), context.read<ScoresCubit>()));
  }

  static void openGameView(BuildContext context) async {
    var result = await Navigator.of(context).push(
      MathGameView.route(context.read<AppSettingsCubit>()),
    );
    if (result is MathTestResult) {
      context.read<ScoresCubit>().addScore(result);
    }
  }

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => page());
  }

  static Widget page() {
    return BlocProvider(
        create: (context) => AppSettingsCubit(),
        child: BlocProvider(
          create: (context) => ScoresCubit(),
          child: const MainPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: const [
        TransitionAppBar(),
        ScoresList(),
      ],
    ));
  }
}

class TransitionAppBar extends StatelessWidget {
  const TransitionAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    EdgeInsets padding = data.padding;

    var sessionType =
        context.select((AppSettingsCubit s) => s.state.mathSessionType);
    var problemsSolved = context.select(
        (ScoresCubit s) => s.state.getProblemsSolvedBySessionName(sessionType));
    var averageSpeed = context.select(
        (ScoresCubit s) => s.state.getAverageSpeedBySessionName(sessionType));
    var averageAccuracy = context.select((ScoresCubit s) =>
        s.state.getAverageAccuracyBySessionName(sessionType));

    return SliverPersistentHeader(
      pinned: true,
      delegate: _TransitionAppBarDelegate(
        safeTopPadding: padding.top,
        problemsSolved: problemsSolved,
        averageAccuracy: averageAccuracy,
        averageSpeed: averageSpeed,
        sessionType: sessionType,
      ),
    );
  }
}

class _TransitionAppBarDelegate extends SliverPersistentHeaderDelegate {
  static const kAppBarHeight = 56.0;
  static const kButtonRadius = 30.0;
  static const kButtonCutoutRadius = 40.0;
  static const kBottomPadding = 8.0;

  final double extent = 300;
  final double safeTopPadding;

  final double averageSpeed;
  final double averageAccuracy;
  final int problemsSolved;
  final String sessionType;

  _TransitionAppBarDelegate({
    required this.sessionType,
    required this.averageSpeed,
    required this.averageAccuracy,
    required this.problemsSolved,
    required this.safeTopPadding,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    double extendedValue = 1 - shrinkOffset / (maxExtent - minExtent);
    extendedValue = min(max(0, extendedValue), 1);

    double reflectionOpacity = min(max(0, (extendedValue - 0.7) * 3), 1);
    double smallStatsOpacity = min(max(0, (extendedValue - 0.1) * 1.5), 1);
    double centerStatsOpacity = min(max(0, (extendedValue - 0.4) * 2), 1);

    var theme = CustomTheme.of(context);

    var bottomColor =
        Color.lerp(theme.primaryColor, theme.secondaryColor, extendedValue)!;
    var buttonColor = Color.lerp(theme.primaryColor, bottomColor, 0.8)!;

    var accuracyPercent = (averageAccuracy * 100).toStringAsFixed(1);
    var speedRounded = averageSpeed.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: kBottomPadding),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            // background decoration and shape
            child: Container(
              margin: EdgeInsets.only(bottom: kButtonRadius),
              decoration: ShapeDecoration(
                  shadows: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6.0,
                      spreadRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 1.0),
                    colors: [theme.primaryColor, bottomColor],
                  ),
                  shape: AppBarShapeBorder(cutoutRadius: kButtonCutoutRadius)),
            ),
          ),
          Positioned.fill(
            // reflection
            child: Opacity(
              opacity: reflectionOpacity,
              child: Padding(
                padding: EdgeInsets.only(top: (1 - extendedValue) * 100),
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment(0.0, 1.0),
                      colors: const [
                        Colors.white12,
                        Color(0x00FFFFFF),
                      ],
                    ),
                    shape: ReflectionShape(
                        leftPadding: safeTopPadding + kAppBarHeight * 2,
                        rightPadding: safeTopPadding + kAppBarHeight,
                        radius: 1.3), //CustomShapeBorder()
                  ),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: AppBar(
                toolbarHeight: kAppBarHeight,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: <Widget>[
                  GestureDetector(
                    child: Lottie.asset('assets/gear.json'),
                    onTap: () => MainPage.openSettings(context),
                  ),
                  // IconButton(
                  //   icon: Lottie.asset('assets/gear.json'),
                  //   // Icon(
                  //   //   Icons.settings,
                  //   // ),
                  //   onPressed: () => MainPage.openSettings(context),
                  // ),
                ],
                title: Row(children: [
                  Text("Difficulty"),
                  Opacity(
                    opacity: smallStatsOpacity,
                    child: Text(" - $sessionType"),
                  ),
                ]),
              )),
          Align(
            alignment: Alignment.center,
            child: AppBarStatText(
              opacity: centerStatsOpacity,
              mainData: true,
              name: "Questions Answered",
              value: "$problemsSolved",
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: kButtonCutoutRadius, right: kButtonCutoutRadius),
                child: AppBarStatText(
                  opacity: smallStatsOpacity,
                  name: "Speed",
                  value: "$speedRounded p/min",
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: kButtonCutoutRadius, left: kButtonCutoutRadius),
                  child: AppBarStatText(
                    opacity: smallStatsOpacity,
                    name: "Score",
                    value: "$accuracyPercent%",
                  ),
                ),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: StartButton(
              size: kButtonRadius * 2,
              color: buttonColor,
              onPressed: () => MainPage.openGameView(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent =>
      safeTopPadding + kButtonRadius + kAppBarHeight + kBottomPadding;

  @override
  bool shouldRebuild(covariant _TransitionAppBarDelegate oldDelegate) {
    return sessionType != oldDelegate.sessionType ||
        problemsSolved != oldDelegate.problemsSolved ||
        averageAccuracy != oldDelegate.averageAccuracy ||
        averageSpeed != oldDelegate.averageSpeed ||
        safeTopPadding != oldDelegate.safeTopPadding ||
        extent != oldDelegate.extent;
  }
}

class ScoresList extends StatelessWidget {
  const ScoresList({Key? key}) : super(key: key);
  //Showcase keys

  @override
  Widget build(BuildContext context) {
    var sessionType =
        context.select((AppSettingsCubit s) => s.state.mathSessionType);
    var scores = context
        .select((ScoresCubit scores) =>
            scores.state.getResultsBySessionName(sessionType))
        .toList();

    var theme = CustomTheme.of(context);

    if (scores.isEmpty) {
      return SliverFillRemaining(
        child: Center(
            child: Text(
          "No History Recorded",
          style: theme.cardTextHighlighted,
        )),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return MathTestResultCard(scores[scores.length - 1 - index]);
      }, childCount: scores.length),
    );
  }
}
