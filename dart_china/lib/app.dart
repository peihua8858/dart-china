import 'package:dart_china/models/models.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/src/bloc_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'common.dart';
import 'config.dart';
import 'features/features.dart';
import 'repositories/repositories.dart';

class DartChinaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final enablePreview = getIt.get<AppConfig>().enablePreview;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
        RepositoryProvider<UserRepository>(create: (_) => UserRepository()),
        RepositoryProvider<TopicRepository>(create: (_) => TopicRepository()),
        RepositoryProvider<CategoryRepository>(
            create: (_) => CategoryRepository()),
        RepositoryProvider<PostRepository>(create: (_) => PostRepository()),
      ],
      // Global blocs
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => BuglyBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              context.read<AuthRepository>(),
              context.read<UserRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => RegisterBloc(
              context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => AppBloc(
              context.read<UserRepository>(),
              context.read<AuthBloc>(),
              context.read<RegisterBloc>(),
              context.read<BuglyBloc>(),
            )..add(AppInit()),
          ),
        ],
        child: enablePreview
            ? DevicePreview(
                builder: (context) {
                  return _buildApp(context, enablePreview);
                },
              )
            : Builder(builder: (context) {
                return _buildApp(context, enablePreview);
              }),
      ),
    );
  }

  Widget _buildApp(BuildContext context, bool enablePreview) {
    return MaterialApp(
      builder: EasyLoading.init(builder: (context, child) {
        if (enablePreview) {
          child = DevicePreview.appBuilder(context, child);
        }
        return child!;
      }),
      title: 'Dart China',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.login: (_) => LoginPage(),
        Routes.register: (_) => RegisterPage(),
        Routes.home: (_) => BlocProvider<TopicListBloc>(
              create: (context) => TopicListBloc(
                context.read<CategoryRepository>(),
                context.read<TopicRepository>(),
              ),
              child: HomePage(),
            ),
        Routes.search: (context) => BlocProvider<SearchBloc>(
              create: (context) => SearchBloc(
                context.read<PostRepository>(),
              ),
              child: SearchPage(),
            ),
        Routes.notification: (_) => BlocProvider<NotificationBloc>(
              create: (context) => NotificationBloc(
                context.read<UserRepository>(),
              ),
              child: NotificationPage(),
            ),
      },
      onGenerateRoute: (settings) => _generateRoutes(settings, context),
    );
  }

  Route<dynamic>? _generateRoutes(
      RouteSettings settings, BuildContext context) {
    var routeName = settings.name;
    if (routeName == Routes.topic) {
      final topicId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => BlocProvider<TopicBloc>(
          create: (context) => TopicBloc(
            context.read<TopicRepository>(),
            context.read<PostRepository>(),
          ),
          child: TopicPage(
            topicId: topicId,
          ),
        ),
      );
    } else if (routeName == Routes.profile) {
      var username;
      if (settings.arguments != null) {
        username = settings.arguments as String;
      }
      return MaterialPageRoute(
        builder: (_) => BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            context.read<UserRepository>(),
            context.read<TopicRepository>(),
          ),
          child: ProfilePage(
            username: username,
          ),
        ),
      );
    } else if (routeName == Routes.post) {
      final args = settings.arguments as PostArguments;
      return MaterialPageRoute(
        builder: (_) => BlocProvider<PostBloc>(
          create: (context) => PostBloc(
            context.read<TopicRepository>(),
            context.read<PostRepository>(),
          ),
          child: PostPage(
            isTopic: args.isTopic,
            postId: args.postId,
            topicId: args.topicId,
          ),
        ),
      );
    }
  }
}
