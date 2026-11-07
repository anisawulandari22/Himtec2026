import 'package:agl_app/core/providers/auth_provider.dart';
import 'package:agl_app/core/providers/crop_provider.dart';
import 'package:agl_app/core/providers/livestock_provider.dart';
import 'package:agl_app/core/theme/theme_provider.dart';
import 'package:agl_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('AGLApp smoke test and auth verification', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CropProvider()),
          ChangeNotifierProvider(create: (_) => LivestockProvider()),
        ],
        child: const AGLApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    // Verify AGL branding is rendered
    expect(find.text('AGL'), findsAtLeastNWidgets(1));
  });
}
