import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/config/routes/routes.dart';
import '/config/theme/app_theme.dart';
import '/cubits/anime_title_language_cubit.dart';
import 'cubits/theme_cubit.dart';
import '/screens/home_screen.dart';
import 'models/anime_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(AnimeAdapter());
  await Hive.openBox<Anime>('watchlistBox');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => AnimeTitleLanguageCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        final themeMode = state;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Animek App',
          themeMode: themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const HomeScreen(),
          onGenerateRoute: onGenerateRoute,
        );
      },
    );
  }
}
