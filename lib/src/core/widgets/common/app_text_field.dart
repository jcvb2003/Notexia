import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final bool autofocus;
  final bool isDense;
  final TextAlign textAlign;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final TextStyle? style;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final bool showBorder;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.autofocus = false,
    this.isDense = true,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.style,
    this.onSubmitted,
    this.onEditingComplete,
    this.onChanged,
    this.showBorder = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      textAlign: textAlign,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      style: style ?? Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        isDense: isDense,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: const BorderSide(color: AppColors.border),
              )
            : InputBorder.none,
        enabledBorder: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: const BorderSide(color: AppColors.border),
              )
            : InputBorder.none,
        focusedBorder: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                borderSide: const BorderSide(color: AppColors.primary),
              )
            : InputBorder.none,
      ),
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
    );
  }
}
