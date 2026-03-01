import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_painter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final elements = <CanvasElement>[
    RectangleElement(
      id: 'r1',
      x: 40,
      y: 30,
      width: 100,
      height: 70,
      strokeColor: const Color(0xFF1F2937),
      fillColor: const Color(0xFFE5E7EB),
      strokeWidth: 2,
      updatedAt: DateTime(2026, 1, 1),
    ),
    LineElement(
      id: 'l1',
      x: 170,
      y: 40,
      width: 90,
      height: 60,
      strokeColor: const Color(0xFF1971C2),
      strokeWidth: 2,
      updatedAt: DateTime(2026, 1, 1),
      points: const [Offset(0, 0), Offset(90, 60)],
    ),
  ];

  Widget buildPainterScene({
    required double zoom,
    required Offset pan,
    required Set<String> selectedIds,
    Rect? selectionBox,
    String? hoveredElementId,
    List<SnapGuide> snapGuides = const [],
    List<Offset> eraserTrail = const [],
    bool isEraserActive = false,
    CanvasElement? activeDrawingElement,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const ValueKey('scene_boundary'),
            child: SizedBox(
              width: 320,
              height: 220,
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(320, 220),
                    painter: StaticCanvasPainter(
                      elements: elements,
                      zoomLevel: zoom,
                      panOffset: pan,
                    ),
                  ),
                  CustomPaint(
                    size: const Size(320, 220),
                    painter: DynamicCanvasPainter(
                      elements: elements,
                      selectedElementIds: selectedIds,
                      zoomLevel: zoom,
                      panOffset: pan,
                      selectionBox: selectionBox,
                      hoveredElementId: hoveredElementId,
                      eraserTrail: eraserTrail,
                      isEraserActive: isEraserActive,
                      snapGuides: snapGuides,
                      activeDrawingElement: activeDrawingElement,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('canvas painter baseline', (tester) async {
    await tester.pumpWidget(
      buildPainterScene(
        zoom: 1.0,
        pan: Offset.zero,
        selectedIds: const {'r1'},
        hoveredElementId: 'l1',
      ),
    );

    await expectLater(
      find.byKey(const ValueKey('scene_boundary')),
      matchesGoldenFile(
        'goldens/canvas_painter_baseline.png',
      ),
    );
  });

  testWidgets('canvas painter overlays and zoomed viewport', (tester) async {
    await tester.pumpWidget(
      buildPainterScene(
        zoom: 1.5,
        pan: const Offset(-20, 10),
        selectedIds: const {'r1'},
        selectionBox: const Rect.fromLTWH(20, 20, 160, 120),
        hoveredElementId: 'r1',
        snapGuides: const [
          SnapGuide(isVertical: true, offset: 120, min: 0, max: 220),
          SnapGuide(isVertical: false, offset: 90, min: 0, max: 320),
        ],
        eraserTrail: const [Offset(200, 120), Offset(220, 135), Offset(240, 125)],
        isEraserActive: true,
      ),
    );

    await expectLater(
      find.byKey(const ValueKey('scene_boundary')),
      matchesGoldenFile(
        'goldens/canvas_painter_overlays_zoomed.png',
      ),
    );
  });
}
