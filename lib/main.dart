import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/crop_provider.dart';
import 'core/providers/livestock_provider.dart';
import 'core/providers/growth_record_provider.dart';
import 'core/router/app_router.dart';
import 'core/services/gemini_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GeminiService.init();

  // Enforce consistent edge-to-edge transparent system overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CropProvider()),
        ChangeNotifierProvider(create: (_) => LivestockProvider()),
        ChangeNotifierProvider(create: (_) => GrowthRecordProvider()),
      ],
      child: const AGLApp(),
    ),
  );
}

class AGLApp extends StatefulWidget {
  const AGLApp({super.key});

  @override
  State<AGLApp> createState() => _AGLAppState();
}

class _AGLAppState extends State<AGLApp> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_router == null) {
      final authProvider = context.read<AuthProvider>();
      _router = AppRouter.createRouter(authProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      routerConfig: _router,
    );
  }
}
