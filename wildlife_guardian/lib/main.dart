import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wildlife_guardian/theme/app_theme.dart';
import 'package:wildlife_guardian/screens/home_screen.dart';
import 'package:wildlife_guardian/screens/alerts_screen.dart';
import 'package:wildlife_guardian/screens/wildlife_detection_screen.dart';
import 'package:wildlife_guardian/screens/target_spot_screen.dart';
import 'package:wildlife_guardian/screens/news_screen.dart';
import 'package:wildlife_guardian/screens/illegal_activity_screen.dart';
import 'package:wildlife_guardian/screens/replantation_finder_screen.dart';
import 'package:wildlife_guardian/screens/deforested_areas_screen.dart';
import 'package:wildlife_guardian/screens/settings_screen.dart';
import 'package:wildlife_guardian/models/user_profile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Wildlife Guardian',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Colors.green,
          secondary: Colors.lightBlue,
          tertiary: Colors.orange,
        ),
        textTheme: GoogleFonts.robotoTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/alerts': (context) => const AlertsScreen(),
        '/wildlife': (context) => const WildlifeDetectionScreen(),
        '/target_spot': (context) => const TargetSpotScreen(),
        '/news': (context) => const NewsScreen(),
        '/illegal_activity': (context) => const IllegalActivityScreen(),
        '/replantation': (context) => const ReplantationFinderScreen(),
        '/deforested_areas': (context) => const DeforestedAreasScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
