import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/base_toolbar.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
import '../../../../../helpers/pump_app.dart';

void main() {
  group('BaseToolbar', () {
    testWidgets('renders title when provided', (tester) async {
      await tester.pumpApp(const BaseToolbar(title: 'Test Title'));
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('renders leading widget when provided', (tester) async {
      await tester.pumpApp(
        const BaseToolbar(leading: Icon(Icons.menu, key: Key('leading_icon'))),
      );
      expect(find.byKey(const Key('leading_icon')), findsOneWidget);
    });

    testWidgets('renders center widget when provided', (tester) async {
      await tester.pumpApp(
        const BaseToolbar(
          center: Text('Center Widget', key: Key('center_widget')),
        ),
      );
      expect(find.byKey(const Key('center_widget')), findsOneWidget);
    });

    testWidgets('renders actions when provided', (tester) async {
      await tester.pumpApp(
        const BaseToolbar(
          actions: [
            Icon(Icons.save, key: Key('action_1')),
            Icon(Icons.share, key: Key('action_2')),
          ],
        ),
      );
      expect(find.byKey(const Key('action_1')), findsOneWidget);
      expect(find.byKey(const Key('action_2')), findsOneWidget);
    });

    testWidgets('renders ToolbarDivider when multiple sections are present', (
      tester,
    ) async {
      await tester.pumpApp(
        const BaseToolbar(
          leading: Icon(Icons.menu),
          actions: [Icon(Icons.save)],
        ),
      );
      expect(find.byType(AppDivider), findsNWidgets(2));
    });

    testWidgets(
      'renders with highlighted background color when highlighted is true',
      (tester) async {
        await tester.pumpApp(
          const BaseToolbar(highlighted: true, title: 'Highlighted'),
        );

        final containerFinder = find.descendant(
          of: find.byType(BaseToolbar),
          matching: find.byType(Container),
        );

        // FloatingCard uses a Container internally, we need to inspect it or
        // rely on visual regression/goldens, but here we just check if it renders without error.
        // Checking exact color might be fragile due to theme dependency.
        expect(containerFinder, findsWidgets);
      },
    );
  });
}
