import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:sahayak/core/theme/app_theme.dart';
import 'package:sahayak/presentation/bloc/theme/theme_bloc.dart';
import 'package:sahayak/presentation/bloc/language/language_bloc.dart';
import 'package:sahayak/presentation/pages/splash/splash_page.dart';
import 'package:sahayak/core/routes/app_router.dart';

class SahayakApp extends StatelessWidget {
  const SahayakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => LanguageBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, languageState) {
              return MaterialApp(
                title: 'Sahayak AI Assistant',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                onGenerateRoute: AppRouter.generateRoute,
                home: const SplashPage(),
              );
            },
          );
        },
      ),
    );
  }
}