import 'package:flutter/material.dart';
import '../../models/wizard_form_data.dart';
import '../../utils/form_validators.dart';

/// Step 4: Review & Submit
class Step4Review extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final WizardFormData formData;
  final ValueChanged<int> onJumpToStep;
  final ValueChanged<bool> onConfirmationChanged;
  final bool isConfirmed;

  const Step4Review({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onJumpToStep,
    required this.onConfirmationChanged,
    required this.isConfirmed,
  });

  @override
  State<Step4Review> createState() => _Step4ReviewState();
}

class _Step4ReviewState extends State<Step4Review> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = widget.formData;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            theme,
            title: 'Review & Submit',
            description: 'Double check your entries. You can jump back to edit any section.',
          ),
          const SizedBox(height: 20),

          // Card 1: Personal Information
          _buildReviewCard(
            theme: theme,
            title: 'Personal Information',
            icon: Icons.person_outline_rounded,
            onEdit: () => widget.onJumpToStep(0),
            entries: [
              {'label': 'Full Name', 'value': data.fullName.isEmpty ? 'Not set' : data.fullName},
              {'label': 'Gender', 'value': data.gender},
              {
                'label': 'Date of Birth',
                'value': '${data.formattedBirthDate} (${data.age ?? "-"} yrs)'
              },
              {'label': 'ID Number', 'value': data.idNumber.isEmpty ? 'Not set' : data.idNumber},
            ],
          ),
          const SizedBox(height: 16),

          // Card 2: Contact Details
          _buildReviewCard(
            theme: theme,
            title: 'Contact Details',
            icon: Icons.contact_mail_outlined,
            onEdit: () => widget.onJumpToStep(1),
            entries: [
              {'label': 'Email', 'value': data.email.isEmpty ? 'Not set' : data.email},
              {'label': 'Phone', 'value': data.phone.isEmpty ? 'Not set' : data.phone},
              {
                'label': 'Address',
                'value': data.streetAddress.isEmpty ? 'Not set' : data.streetAddress
              },
              {'label': 'City & Postal', 'value': '${data.city}, ${data.postalCode}'},
              {'label': 'Country', 'value': data.country},
            ],
          ),
          const SizedBox(height: 16),

          // Card 3: Preferences & Settings
          _buildReviewCard(
            theme: theme,
            title: 'Preferences & Settings',
            icon: Icons.tune_rounded,
            onEdit: () => widget.onJumpToStep(2),
            entries: [
              {'label': 'Primary Role', 'value': data.role},
              {'label': 'Notification Channel', 'value': data.communicationChannel},
              {'label': 'Interface Theme', 'value': data.themePreference},
              {'label': 'Weekly Digest', 'value': data.subscribeNewsletter ? 'Subscribed' : 'No'},
              {'label': 'Two-Factor Auth', 'value': data.enable2FA ? 'Enabled' : 'Disabled'},
              {'label': 'Privacy Terms', 'value': data.agreeDataPrivacy ? 'Accepted' : 'Pending'},
            ],
          ),
          const SizedBox(height: 20),

          // Final verification checkbox
          FormField<bool>(
            initialValue: widget.isConfirmed,
            validator: (val) => FormValidators.validateFinalConfirmation(widget.isConfirmed),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (state) {
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: state.hasError
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary.withValues(alpha: 0.4),
                    width: state.hasError ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: widget.isConfirmed,
                          activeColor: theme.colorScheme.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: (val) {
                            widget.onConfirmationChanged(val ?? false);
                            state.didChange(val);
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              'I certify that all the information provided above is complete, accurate, and submitted in good faith.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
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
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
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
              child: Icon(Icons.fact_check_rounded, color: theme.colorScheme.primary, size: 22),
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

  Widget _buildReviewCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required VoidCallback onEdit,
    required List<Map<String, String>> entries,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          // Header with Edit button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Entries
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(
                          e['label']!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e['value']!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
