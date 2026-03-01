import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppSegmentedToggle<T> extends StatelessWidget {
  final String? label;
  final T value;
  final Map<T, dynamic> options;
  final ValueChanged<T> onChanged;

  const AppSegmentedToggle({
    super.key,
    this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty) ...[
          Text(label!, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 12),
        ],
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.gray100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: options.entries.map((entry) {
              final isSelected = entry.key == value;
              return GestureDetector(
                onTap: () => onChanged(entry.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.selectedBackground
                        : AppColors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.selectedBackground
                                  .withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: _buildContent(context, entry.value, isSelected),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, dynamic content, bool isSelected) {
    final color =
        isSelected ? AppColors.selectedForeground : AppColors.textSecondary;

    if (content is IconData) {
      return Icon(content, size: 18, color: color);
    } else if (content is String) {
      return Text(
        content,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
            ),
      );
    } else if (content is Widget) {
      return content;
    }
    return const SizedBox.shrink();
  }
}
