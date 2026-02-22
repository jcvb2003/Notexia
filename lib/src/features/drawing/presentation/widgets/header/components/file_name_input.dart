import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/common/app_text_field.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';

class FileNameInput extends StatefulWidget {
  const FileNameInput({super.key});

  @override
  State<FileNameInput> createState() => _FileNameInputState();
}

class _FileNameInputState extends State<FileNameInput> {
  bool _isEditing = false;
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing(String currentTitle) {
    setState(() {
      _isEditing = true;
      _controller.text = currentTitle;
    });
    _focusNode.requestFocus();
  }

  void _submit() {
    setState(() {
      _isEditing = false;
    });
    context.read<CanvasCubit>().updateTitle(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final title = context.select<CanvasCubit, String>(
      (cubit) => cubit.state.document.title,
    );
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300,
        minHeight: AppSizes.buttonSmall,
      ),
      child: _isEditing
          ? AppTextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              textAlign: TextAlign.center,
              showBorder: false,
              contentPadding: EdgeInsets.zero,
              onSubmitted: (_) => _submit(),
              onEditingComplete: _submit,
            )
          : InkWell(
              onTap: () => _startEditing(title),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
    );
  }
}
