import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set up Bloc Observer
  Bloc.observer = AppBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ne')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const SahayakApp(),
    ),
  );
}

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    debugPrint('${bloc.runtimeType} created');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} changed: $change');
  }
}
