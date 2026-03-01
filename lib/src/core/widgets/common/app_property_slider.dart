import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppPropertySlider extends StatelessWidget {
  final String? label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const AppPropertySlider({
    super.key,
    this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  static String formatValue(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label!, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                formatValue(value),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
