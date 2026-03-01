import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/common/app_divider.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('AppDivider', () {
    testWidgets('uses default dimensions, padding and border color', (
      tester,
    ) async {
      await tester.pumpApp(const AppDivider());

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(AppDivider),
          matching: find.byType(Padding),
        ),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppDivider),
          matching: find.byType(Container),
        ),
      );

      expect(
        padding.padding,
        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      );
      expect(container.constraints, isNotNull);
      expect(container.constraints?.minWidth, 1.0);
      expect(container.constraints?.maxWidth, 1.0);
      expect(container.color, AppColors.border);
    });

    testWidgets('toolbar constructor applies toolbar-specific tokens', (
      tester,
    ) async {
      await tester.pumpApp(const AppDivider.toolbar());

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(AppDivider),
          matching: find.byType(Padding),
        ),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppDivider),
          matching: find.byType(Container),
        ),
      );

      expect(
        padding.padding,
        const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 0),
      );
      expect(container.constraints?.minWidth, 1.0);
      expect(container.constraints?.maxWidth, 1.0);
      expect(container.constraints?.minHeight, 24.0);
      expect(container.constraints?.maxHeight, 24.0);
      expect(container.color, AppColors.border);
    });

    testWidgets('accepts custom dimensions, padding and color', (tester) async {
      await tester.pumpApp(
        const AppDivider(
          height: 12,
          width: 3,
          horizontalPadding: 5,
          verticalPadding: 7,
          color: Colors.red,
        ),
      );

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(AppDivider),
          matching: find.byType(Padding),
        ),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppDivider),
          matching: find.byType(Container),
        ),
      );

      expect(
        padding.padding,
        const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
      );
      expect(container.constraints?.minWidth, 3.0);
      expect(container.constraints?.maxWidth, 3.0);
      expect(container.constraints?.minHeight, 12.0);
      expect(container.constraints?.maxHeight, 12.0);
      expect(container.color, Colors.red);
    });
  });
}
