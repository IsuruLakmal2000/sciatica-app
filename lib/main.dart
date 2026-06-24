import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'state/app_state.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/exercise_library_screen.dart';
import 'screens/pain_diary_screen.dart';
import 'screens/education_screen.dart';
import 'screens/profile_screen.dart';
import 'l10n/app_localizations.dart';
import 'services/ad_service.dart';
import 'services/subscription_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SubscriptionService.initialize();
  AdService.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.darkSurface,
    ),
  );
  runApp(const SciaticaApp());
}

class SciaticaApp extends StatefulWidget {
  const SciaticaApp({super.key});

  @override
  State<SciaticaApp> createState() => _SciaticaAppState();
}

class _SciaticaAppState extends State<SciaticaApp> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.initialize();
    AppColors.isDark = _appState.profile.darkMode;
    _appState.addListener(_onStateChange);
  }

  void _onStateChange() {
    AppColors.isDark = _appState.profile.darkMode;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: _appState,
      child: MaterialApp(
        title: 'Sciatica Relief',
        debugShowCheckedModeBanner: false,
        theme: _appState.profile.darkMode
            ? AppTheme.darkTheme
            : AppTheme.lightTheme,
        locale: Locale(_appState.languageCode),
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
          Locale('fr', ''),
          Locale('de', ''),
          Locale('it', ''),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: _appState.isLoading
            ? const _SplashScreen()
            : _appState.hasCompletedOnboarding
            ? const MainNavigation()
            : const OnboardingScreen(),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.burntOrange, AppColors.burntOrangeLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.burntOrange.withAlpha(50),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.healing, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              'Sciatica Relief',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.burntOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          ExerciseLibraryScreen(),
          PainDiaryScreen(),
          EducationScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.warmBorder, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 2) {
              AdService.showNextDayAdIfApplicable(context);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: context.l10n('nav_home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center),
              label: context.l10n('nav_exercises'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.edit_note),
              label: context.l10n('nav_diary'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.menu_book_rounded),
              label: context.l10n('nav_learn'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded),
              label: context.l10n('nav_profile'),
            ),
          ],
        ),
      ),
    );
  }
}
