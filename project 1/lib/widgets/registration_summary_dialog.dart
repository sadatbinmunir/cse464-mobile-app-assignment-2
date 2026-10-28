import 'package:flutter/material.dart';
import '../models/user_registration.dart';

/// Modal dialog displaying registration submission details
class RegistrationSummaryDialog extends StatelessWidget {
  final UserRegistration user;
  final VoidCallback onReset;

  const RegistrationSummaryDialog({
    super.key,
    required this.user,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Icon and Title
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade300, width: 2),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 40,
                    color: Colors.green.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Registration Successful!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'All validations passed successfully',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Scrollable Details
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildInfoTile(
                        context,
                        icon: Icons.person_outline,
                        label: 'Full Name',
                        value: user.fullName,
                      ),
                      _buildInfoTile(
                        context,
                        icon: Icons.email_outlined,
                        label: 'Email Address',
                        value: user.email,
                      ),
                      _buildInfoTile(
                        context,
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        value: user.phone,
                      ),
                      _buildInfoTile(
                        context,
                        icon: Icons.badge_outlined,
                        label: 'National ID (NID)',
                        value: user.nid,
                      ),
                      _buildInfoTile(
                        context,
                        icon: Icons.calendar_today_outlined,
                        label: 'Date of Birth & Age',
                        value: '${user.formattedBirthDate} (${user.age} yrs)',
                      ),
                      _buildInfoTile(
                        context,
                        icon: Icons.public_outlined,
                        label: 'Country',
                        value: '${user.country.flag} ${user.country.name} (${user.country.dialCode})',
                      ),
                      _buildInfoTile(
                        context,
                        icon: Icons.wc_outlined,
                        label: 'Gender',
                        value: user.gender,
                      ),
                      _buildInfoTile(
                        context,
                        icon: Icons.stars_outlined,
                        label: 'Interests (${user.interests.length})',
                        value: user.interests.join(', '),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('New Entry'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onReset();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.done_all_rounded, size: 18),
                      label: const Text('Close'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Navigator.pop(context),
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

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
