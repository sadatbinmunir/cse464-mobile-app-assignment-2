import 'package:flutter/material.dart';
import '../../models/wizard_form_data.dart';
import '../../utils/form_validators.dart';

/// Step 3: Preferences & Settings
class Step3Preferences extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final WizardFormData formData;
  final VoidCallback onStateChanged;

  const Step3Preferences({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onStateChanged,
  });

  @override
  State<Step3Preferences> createState() => _Step3PreferencesState();
}

class _Step3PreferencesState extends State<Step3Preferences> {
  static const List<String> _roles = [
    'Student',
    'Software Engineer',
    'Researcher / Faculty',
    'UI/UX Designer',
    'Product Manager',
    'Other',
  ];

  static const List<Map<String, dynamic>> _channels = [
    {'title': 'Email', 'icon': Icons.email_outlined, 'desc': 'Important notices & digests'},
    {'title': 'SMS', 'icon': Icons.sms_outlined, 'desc': 'Security alerts & urgent updates'},
    {'title': 'Push', 'icon': Icons.notifications_active_outlined, 'desc': 'Instant real-time app badges'},
  ];

  static const List<Map<String, dynamic>> _themes = [
    {'title': 'System', 'icon': Icons.brightness_auto_rounded},
    {'title': 'Light', 'icon': Icons.light_mode_rounded},
    {'title': 'Dark', 'icon': Icons.dark_mode_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            theme,
            title: 'Preferences & Settings',
            description: 'Customize notifications, security, and app experience.',
          ),
          const SizedBox(height: 20),

          // Role / Professional Field
          Text(
            'Primary Role / Category *',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _roles.map((r) {
              final isSelected = widget.formData.role == r;
              return ChoiceChip(
                label: Text(r),
                selected: isSelected,
                selectedColor: theme.colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => widget.formData.role = r);
                    widget.onStateChanged();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Communication Channel
          Text(
            'Preferred Notification Channel *',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: _channels.map((ch) {
              final title = ch['title'] as String;
              final icon = ch['icon'] as IconData;
              final desc = ch['desc'] as String;
              final isSelected = widget.formData.communicationChannel == title;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () {
                    setState(() => widget.formData.communicationChannel = title);
                    widget.onStateChanged();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
                          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                desc,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Theme Preference
          Text(
            'Theme Preference',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: _themes.map((t) {
              return ButtonSegment<String>(
                value: t['title'] as String,
                label: Text(t['title'] as String),
                icon: Icon(t['icon'] as IconData, size: 18),
              );
            }).toList(),
            selected: {widget.formData.themePreference},
            onSelectionChanged: (set) {
              setState(() => widget.formData.themePreference = set.first);
              widget.onStateChanged();
            },
          ),
          const SizedBox(height: 20),

          // Switches: Newsletter & 2FA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Subscribe to Weekly Digest', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Receive curated technical articles & CSE news'),
                  value: widget.formData.subscribeNewsletter,
                  activeThumbColor: theme.colorScheme.primary,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    setState(() => widget.formData.subscribeNewsletter = val);
                    widget.onStateChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Enable Two-Factor Authentication', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Extra security protection for login sessions'),
                  value: widget.formData.enable2FA,
                  activeThumbColor: theme.colorScheme.primary,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (val) {
                    setState(() => widget.formData.enable2FA = val);
                    widget.onStateChanged();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Mandatory Privacy Agreement Checkbox
          FormField<bool>(
            initialValue: widget.formData.agreeDataPrivacy,
            validator: (val) => FormValidators.validatePrivacyAgreement(widget.formData.agreeDataPrivacy),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: widget.formData.agreeDataPrivacy,
                        activeColor: theme.colorScheme.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (val) {
                          setState(() => widget.formData.agreeDataPrivacy = val ?? false);
                          state.didChange(val);
                          widget.onStateChanged();
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text.rich(
                            TextSpan(
                              text: 'I acknowledge and agree to the ',
                              style: theme.textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: ' and consent to secure data processing.'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (state.hasError) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        state.errorText ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(ThemeData theme, {required String title, required String description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.tune_rounded, color: theme.colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
