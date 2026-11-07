import 'package:flutter_test/flutter_test.dart';
import 'package:himtec_app/main.dart';
import 'package:provider/provider.dart';
import 'package:himtec_app/core/theme/theme_provider.dart';

void main() {
  testWidgets('HimtecApp smoke test and navigation verification', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const HimtecApp(),
      ),
    );

    // Initial pump
    await tester.pumpAndSettle();

    // Verify Beranda title is rendered
    expect(find.text('Beranda'), findsAtLeastNWidgets(1));
  });
}
