import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_test/game/training.dart';
import 'package:math_test/scores/cubit/scored_bloc.dart';
import 'package:math_test/settings/cubit/app_settings_cubit.dart';
import 'package:math_test/settings/view/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Route route(AppSettingsCubit settings, ScoresCubit scores) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: scores,
        child: BlocProvider.value(
          value: settings,
          child: const SettingsPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7CB9E8),
        title: const Text("Settings"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          MathDurationEditor(),
          MathSessionEditor(),
          ClearScoresButton(),
        ],
      ),
    );
  }
}

class ClearScoresButton extends StatelessWidget {
  const ClearScoresButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NameValueCard(
      onTap: () => _showClearScoresDialog(context),
      name: const Text("Clear Scores"),
      value: Container(),
    );
  }

  void _showClearScoresDialog(BuildContext context) async {
    bool? answer = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
              content: const Text("All scores will be deleted"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));

    if (answer == true) {
      context.read<ScoresCubit>().clearScores();
    }
  }
}

class MathDurationEditor extends StatelessWidget {
  const MathDurationEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var duration =
        context.select((AppSettingsCubit c) => c.state.mathSessionDuration);

    return NameValueCard(
      onTap: () => _showDurationSelectDialog(context),
      name: const Text("Game Duration:"),
      value: Text(
        "${duration.inMinutes} min",
        style: const TextStyle(
          color: Colors.black45,
        ),
      ),
    );
  }

  void _showDurationSelectDialog(BuildContext context) {
    List<ListDialogElement<Duration>> elements = MathConstants.durationOptions
        .map((option) => ListDialogElement(
              value: option,
              child: Text("${option.inMinutes} min"),
            ))
        .toList();

    var settings = context.read<AppSettingsCubit>();

    ListDialog(
      elements: elements,
      title: "Duration",
      selected: settings.state.mathSessionDuration,
    ).show(context).then((data) {
      if (data != null) settings.mathSessionDuration = data;
    });
  }
}

class MathSessionEditor extends StatelessWidget {
  const MathSessionEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sessionType =
        context.select((AppSettingsCubit c) => c.state.mathSessionType);

    return NameValueCard(
      onTap: () => _showDurationSelectDialog(context),
      name: const Text("Difficulty:"),
      value: Text(
        sessionType,
        style: const TextStyle(color: Colors.black45),
      ),
    );
  }

  void _showDurationSelectDialog(BuildContext context) {
    List<ListDialogElement<String>> elements =
        MathConstants.sessionDifficultyNames
            .map(
              (option) => ListDialogElement(
                value: option,
                child: Text(option),
              ),
            )
            .toList();

    var settings = context.read<AppSettingsCubit>();

    ListDialog(
      elements: elements,
      title: "Difficulty",
      selected: settings.state.mathSessionType,
    ).show(context).then((data) {
      if (data != null) settings.mathSessionType = data;
    });
  }
}
