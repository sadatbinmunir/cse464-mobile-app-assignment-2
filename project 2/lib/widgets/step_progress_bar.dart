import 'package:flutter/material.dart';

/// Interactive visual progress bar displaying the 4 wizard steps
class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int> onStepTapped;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  static const List<Map<String, dynamic>> steps = [
    {'title': 'Personal', 'subtitle': 'Basic Info', 'icon': Icons.person_rounded},
    {'title': 'Contact', 'subtitle': 'Reach & Address', 'icon': Icons.contact_mail_rounded},
    {'title': 'Preferences', 'subtitle': 'Settings', 'icon': Icons.tune_rounded},
    {'title': 'Review', 'subtitle': 'Verification', 'icon': Icons.fact_check_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressFraction = (currentStep + 1) / steps.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Step Counter & Percentage Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentStep + 1} of ${steps.length}: ${steps[currentStep]['title']}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(progressFraction * 100).toInt()}% Completed',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Linear animated progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0, end: progressFraction),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // 4 Interactive Step Circles with connecting lines
          Row(
            children: List.generate(steps.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Connecting line
                final lineIndex = index ~/ 2;
                final isPassed = lineIndex < currentStep;

                return Expanded(
                  child: Container(
                    height: 2,
                    color: isPassed
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.25),
                  ),
                );
              }

              final stepIndex = index ~/ 2;
              final isCurrent = stepIndex == currentStep;
              final isCompleted = stepIndex < currentStep;
              final item = steps[stepIndex];

              return InkWell(
                onTap: () {
                  // Only allow jumping back to completed steps or current step
                  if (stepIndex <= currentStep) {
                    onStepTapped(stepIndex);
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? Colors.green.shade600
                            : (isCurrent
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainerHighest),
                        border: Border.all(
                          color: isCurrent
                              ? theme.colorScheme.primary
                              : (isCompleted
                                  ? Colors.green.shade600
                                  : theme.colorScheme.outline.withValues(alpha: 0.3)),
                          width: isCurrent ? 2.5 : 1.5,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(Icons.check, size: 18, color: Colors.white)
                            : Text(
                                '${stepIndex + 1}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrent
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                        color: isCurrent
                            ? theme.colorScheme.primary
                            : (isCompleted
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
