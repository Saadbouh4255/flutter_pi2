import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/app_state.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TouristGuideApp());
}

class TouristGuideApp extends StatefulWidget {
  const TouristGuideApp({super.key});

  @override
  State<TouristGuideApp> createState() => _TouristGuideAppState();
}

class _TouristGuideAppState extends State<TouristGuideApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      appState: _appState,
      child: AnimatedBuilder(
        animation: _appState.localization,
        builder: (context, child) {
          final lang = _appState.localization.currentLanguage;
          return MaterialApp(
            title: 'Nouakchott Guide',
            debugShowCheckedModeBanner: false,
            locale: Locale(lang),
            supportedLocales: const [
              Locale('en'),
              Locale('fr'),
              Locale('ar'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
            ),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final AppStateProvider? result =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(result != null, 'No AppStateProvider found in context');
    return result!.notifier!;
  }
}
