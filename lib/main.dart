import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/state.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/component/components.dart';
import 'package:social_app/shared/component/constants.dart';
import 'package:social_app/shared/component/observer.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log(message.data.toString(), name: 'on background message ');
  showToast(text: 'on background message ', state: ToastState.SUCCESS);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();

  log(token.toString(), name: 'token');

  FirebaseMessaging.onMessage.listen((event) {
    log(event.data.toString(), name: 'on message');
    showToast(text: 'on message', state: ToastState.SUCCESS);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    log(event.data.toString(), name: 'on message app');
    showToast(text: 'on message app', state: ToastState.SUCCESS);
  });

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await CacheHelper.init();

  Widget widget;

  uId = CacheHelper.getData(key: 'uId');

  log(uId.toString());
  if (uId != null) {
    widget = const SocialLayout();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialCubit()
        ..getUserData()
        ..getPosts(),
      child: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: SocialCubit.get(context).isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: startWidget,
            );
          }),
    );
  }
}
