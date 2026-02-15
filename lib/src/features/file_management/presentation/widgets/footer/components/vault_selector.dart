import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Widget para exibir o Vault atual e permitir a troca de pasta.
class VaultSelector extends StatefulWidget {
  final String name;
  final String summary;
  final VoidCallback onTap;

  const VaultSelector({
    super.key,
    required this.name,
    required this.summary,
    required this.onTap,
  });

  @override
  State<VaultSelector> createState() => _VaultSelectorState();
}

class _VaultSelectorState extends State<VaultSelector> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovering ? AppColors.gray50 : AppColors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovering ? AppColors.gray200 : AppColors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.gray900,
                    ),
                  ),
                  if (_isHovering) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      LucideIcons.arrowLeftRight,
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                widget.summary,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.gray500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
