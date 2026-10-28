import 'package:flutter/material.dart';
import '../utils/validators.dart';

/// Multi-select checkboxes for areas of interest with validation
class InterestSelector extends StatelessWidget {
  final List<String> selectedInterests;
  final ValueChanged<List<String>> onChanged;

  const InterestSelector({
    super.key,
    required this.selectedInterests,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> _interestOptions = [
    {'title': 'Mobile App Development', 'icon': Icons.phone_android_rounded},
    {'title': 'Web & Full Stack', 'icon': Icons.language_rounded},
    {'title': 'Artificial Intelligence & ML', 'icon': Icons.psychology_rounded},
    {'title': 'Cybersecurity & Networks', 'icon': Icons.security_rounded},
    {'title': 'UI/UX & Product Design', 'icon': Icons.design_services_rounded},
    {'title': 'Cloud & DevOps', 'icon': Icons.cloud_done_rounded},
    {'title': 'Competitive Programming', 'icon': Icons.code_rounded},
    {'title': 'Game Development', 'icon': Icons.sports_esports_rounded},
  ];

  void _toggle(String title) {
    final updated = List<String>.from(selectedInterests);
    if (updated.contains(title)) {
      updated.remove(title);
    } else {
      updated.add(title);
    }
    onChanged(updated);
  }

  void _selectAll() {
    onChanged(_interestOptions.map((e) => e['title'] as String).toList());
  }

  void _clearAll() {
    onChanged([]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<List<String>>(
      initialValue: selectedInterests,
      validator: (val) => Validators.validateInterests(selectedInterests),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Areas of Interest',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: _selectAll,
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text('Select All', style: TextStyle(fontSize: 12)),
                    ),
                    TextButton(
                      onPressed: _clearAll,
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text('Clear', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Material(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: state.hasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.outline.withValues(alpha: 0.25),
                  width: state.hasError ? 1.5 : 1.0,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _interestOptions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: theme.colorScheme.outline.withValues(alpha: 0.15),
                ),
                itemBuilder: (context, index) {
                  final item = _interestOptions[index];
                  final title = item['title'] as String;
                  final icon = item['icon'] as IconData;
                  final isChecked = selectedInterests.contains(title);

                  return CheckboxListTile(
                    value: isChecked,
                    onChanged: (_) {
                      _toggle(title);
                      state.didChange(selectedInterests);
                    },
                    secondary: Icon(
                      icon,
                      size: 20,
                      color: isChecked ? theme.colorScheme.primary : theme.colorScheme.outline,
                    ),
                    title: Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isChecked ? FontWeight.w600 : FontWeight.w500,
                        color: isChecked ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                      ),
                    ),
                    dense: true,
                    activeColor: theme.colorScheme.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    controlAffinity: ListTileControlAffinity.trailing,
                  );
                },
              ),
            ),
            if (state.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  state.errorText ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
