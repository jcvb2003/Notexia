import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppPropertySlider extends StatelessWidget {
  final String? label;
  final double value;
  final double min;
  final double max;
  final int? fractionDigits;
  final ValueChanged<double> onChanged;

  const AppPropertySlider({
    super.key,
    this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.fractionDigits,
  });

  static String formatValue(double value, [int? fractionDigits]) {
    if (fractionDigits != null) {
      return value.toStringAsFixed(fractionDigits);
    }
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
                formatValue(value, fractionDigits),
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
