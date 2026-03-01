import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class AppCompactSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppCompactSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.65,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
