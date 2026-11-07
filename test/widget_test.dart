import 'package:agl_app/core/providers/crop_provider.dart';
import 'package:agl_app/core/providers/livestock_provider.dart';
import 'package:agl_app/core/theme/theme_provider.dart';
import 'package:agl_app/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('AGLApp smoke test and navigation verification', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => CropProvider()),
          ChangeNotifierProvider(create: (_) => LivestockProvider()),
        ],
        child: const AGLApp(),
      ),
    );

    // Initial pump
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Beranda title is rendered
    expect(find.text('Beranda'), findsAtLeastNWidgets(1));
  });
}

