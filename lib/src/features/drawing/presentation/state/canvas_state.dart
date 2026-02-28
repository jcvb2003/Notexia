/// Este arquivo agora atua como um 'barrel', reexportando o estado
/// que foi unido ao arquivo principal do Cúbit para reduzir a fragmentação
/// (OC - Custo de Contexto) sem quebrar os imports existentes.
library;

export 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart'
    show
        CanvasState,
        CanvasTransform,
        InteractionState,
        EraserState,
        EraserMode,
        SnapState,
        TextEditingState;
