import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
import 'package:notexia/src/features/file_management/presentation/utils/file_icon_utils.dart';

class FileIconColorPicker extends StatelessWidget {
  final String? initialIcon;
  final Color? initialColor;
  final Function(String? icon, Color? color) onApply;

  const FileIconColorPicker({
    super.key,
    this.initialIcon,
    this.initialColor,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialIcon,
    Color? initialColor,
    required Function(String? icon, Color? color) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FileIconColorPicker(
        initialIcon: initialIcon,
        initialColor: initialColor,
        onApply: onApply,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _FileIconColorPickerContent(
      initialIcon: initialIcon,
      initialColor: initialColor,
      onApply: onApply,
    );
  }
}

class _FileIconColorPickerContent extends StatefulWidget {
  final String? initialIcon;
  final Color? initialColor;
  final Function(String? icon, Color? color) onApply;

  const _FileIconColorPickerContent({
    this.initialIcon,
    this.initialColor,
    required this.onApply,
  });

  @override
  State<_FileIconColorPickerContent> createState() =>
      _FileIconColorPickerContentState();
}

class _FileIconColorPickerContentState
    extends State<_FileIconColorPickerContent> {
  String? _selectedIcon;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.initialIcon;
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.palette;

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aparência',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Text(
                'Escolha um ícone',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: FileIconUtils.iconMap.entries.map((e) {
                  final isSelected = _selectedIcon == e.key;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = e.key),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.gray100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Icon(
                        e.value,
                        size: 24,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Text(
                'Escolha uma cor',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: colors.map((c) {
                  final isSelected = _selectedColor == c;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = c),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSelected ? AppColors.primary : AppColors.border,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppTextButton(
                    label: 'Limpar',
                    onPressed: () {
                      setState(() {
                        _selectedIcon = null;
                        _selectedColor = null;
                      });
                    },
                  ),
                  const Spacer(),
                  AppTextButton(
                    label: 'Cancelar',
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  AppFilledButton(
                    label: 'Aplicar',
                    onPressed: () {
                      widget.onApply(_selectedIcon, _selectedColor);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
