import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_china/common.dart';
import 'package:dart_china/features/bugly/bloc/bugly_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:equatable/equatable.dart';

import '../../features.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(this._userRepository, this._loginBloc, this._registerBloc,
      this._buglyBloc)
      : super(AppState()) {
    _loginSubscription = _loginBloc.stream.listen((authState) {
      if (authState is LoginSuccess) {
        _updateLogin(true, authState.user);
      }
    });
    _registerSubscription = _registerBloc.stream.listen((authState) {
      if (authState is RegisterSuccess) {
        _updateLogin(true, authState.user);
      }
    });
  }

  final UserRepository _userRepository;
  final LoginBloc _loginBloc;
  final RegisterBloc _registerBloc;
  late StreamSubscription _loginSubscription;
  late StreamSubscription _registerSubscription;
  final BuglyBloc _buglyBloc;

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is AppOpen) {
      if (state.userLogin) {
        _checkNotification(state.user!.username);
      }

      final config = getIt.get<AppConfig>();
      _buglyBloc.add(BuglyInit(
        enableDebug: !config.isProd,
        androidAppId: config.buglyAndroidAppId,
        iosAppId: config.buglyIosAppId,
      ));
    } else if (event is AppHome) {
      if (state.userLogin) {
        _checkNotification(state.user!.username);
      }
    } else if (event is AppShare) {
      _shareTopic(event.url, event.title);
    }
  }

  _updateLogin(bool status, User? user, {bool? notifcation}) {
    emit(state.copyWith(
        userLogin: status, user: user, hasNotification: notifcation));
  }

  _checkNotification(String username) async {
    final has = await _userRepository.hasNotification(username);
    emit(state.copyWith(hasNotification: has));
  }

  _shareTopic(String url, String? title) {
    Share.share('$title $url', subject: title);
  }

  @override
  Future<void> close() {
    _loginSubscription.cancel();
    _registerSubscription.cancel();
    return super.close();
  }
}
