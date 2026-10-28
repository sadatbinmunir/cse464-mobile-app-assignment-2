import 'package:flutter/material.dart';
import '../models/wizard_form_data.dart';

/// Modal dialog celebrating successful completion and submission of the multi-step form
class SubmissionSuccessDialog extends StatelessWidget {
  final WizardFormData formData;
  final VoidCallback onStartNew;

  const SubmissionSuccessDialog({
    super.key,
    required this.formData,
    required this.onStartNew,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Celebration badge
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade300, width: 2),
                  ),
                  child: Icon(
                    Icons.task_alt_rounded,
                    size: 44,
                    color: Colors.green.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Application Submitted!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'All 4 steps completed and verified.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Summary
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSummaryItem(
                        icon: Icons.person_outline,
                        label: 'Applicant',
                        value: formData.fullName,
                        theme: theme,
                      ),
                      _buildSummaryItem(
                        icon: Icons.badge_outlined,
                        label: 'ID Number',
                        value: formData.idNumber,
                        theme: theme,
                      ),
                      _buildSummaryItem(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: formData.email,
                        theme: theme,
                      ),
                      _buildSummaryItem(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: formData.phone,
                        theme: theme,
                      ),
                      _buildSummaryItem(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        value: '${formData.city}, ${formData.country}',
                        theme: theme,
                      ),
                      _buildSummaryItem(
                        icon: Icons.work_outline,
                        label: 'Role',
                        value: formData.role,
                        theme: theme,
                      ),
                      _buildSummaryItem(
                        icon: Icons.notifications_none_outlined,
                        label: 'Notification Channel',
                        value: formData.communicationChannel,
                        theme: theme,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onStartNew();
                      },
                      child: const Text('New Application'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
