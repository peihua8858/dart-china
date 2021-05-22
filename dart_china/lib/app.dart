import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repositories/repositories.dart';
import 'commons.dart';
import 'features/features.dart';

const kReleaseMode = false;

class DartChinaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthRepository()),
        ),
        BlocProvider(
          create: (context) => AppCubit(BlocProvider.of<AuthCubit>(context)),
        ),
        BlocProvider(
          create: (context) =>
              TopicListCubit(TopicRepository(), CategoryRepository()),
        ),
        BlocProvider(
          create: (context) => TopicCubit(PostRepository(), TopicRepository()),
        ),
      ],
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (_) => MaterialApp(
          builder: DevicePreview.appBuilder,
          title: 'Dart China',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: TopicListPage.routeName,
          routes: {
            TopicListPage.routeName: (_) => TopicListPage(),
            LoginPage.routeName: (_) => LoginPage(),
          },
          onGenerateRoute: (settings) => generateRoutes(settings, context),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }

  Route<dynamic>? generateRoutes(RouteSettings settings, BuildContext context) {
    var routeName = settings.name;
    if (routeName == TopicPage.routeName) {
      final topic = settings.arguments as Topic;
      return MaterialPageRoute(
        builder: (_) => TopicPage(
          topic: topic,
        ),
      );
    }
  }
}
