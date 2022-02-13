import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_test/home/home_view.dart';
import 'package:math_test/theme/theme.dart';
import 'package:math_test/widgets/custom_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:showcaseview/showcaseview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),

    // const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CustomTheme(
      data: customThemeData,
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        useInheritedMediaQuery: true,
        title: 'Maths Test',
        theme: materialThemeData,
        home: ShowCaseWidget(
          builder: Builder(
            builder: (context) => MainPage.page(),
          ),
        ),
      ),
    );
  }
}
