import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class TabbedStyleEditor extends StatefulWidget {
  final Map<String, Widget> tabs;

  const TabbedStyleEditor({super.key, required this.tabs});

  @override
  State<TabbedStyleEditor> createState() => _TabbedStyleEditorState();
}

class _TabbedStyleEditorState extends State<TabbedStyleEditor>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    // Rebuild to show the content of the selected tab
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: _tabController,
          tabs: widget.tabs.keys.map((title) => Tab(text: title)).toList(),
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          dividerColor: AppColors.border,
          labelStyle: context.typography.labelMedium,
          unselectedLabelStyle: context.typography.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: widget.tabs.values.elementAt(_tabController.index),
        ),
      ],
    );
  }
}
