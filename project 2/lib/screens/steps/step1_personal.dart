import 'package:flutter/material.dart';
import '../../models/wizard_form_data.dart';
import '../../utils/form_validators.dart';
import '../../widgets/custom_text_input.dart';

/// Step 1: Personal Information
class Step1Personal extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final WizardFormData formData;
  final VoidCallback onStateChanged;

  const Step1Personal({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onStateChanged,
  });

  @override
  State<Step1Personal> createState() => _Step1PersonalState();
}

class _Step1PersonalState extends State<Step1Personal> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.formData.firstName);
    _lastNameController = TextEditingController(text: widget.formData.lastName);
    _idController = TextEditingController(text: widget.formData.idNumber);
  }

  @override
  void didUpdateWidget(covariant Step1Personal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.formData.firstName != _firstNameController.text) {
      _firstNameController.text = widget.formData.firstName;
    }
    if (widget.formData.lastName != _lastNameController.text) {
      _lastNameController.text = widget.formData.lastName;
    }
    if (widget.formData.idNumber != _idController.text) {
      _idController.text = widget.formData.idNumber;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = widget.formData.birthDate ?? DateTime(now.year - 20, now.month, now.day);
    final firstDate = DateTime(now.year - 100, 1, 1);
    final lastDate = now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select Date of Birth',
    );

    if (picked != null) {
      setState(() {
        widget.formData.birthDate = picked;
        int age = now.year - picked.year;
        if (now.month < picked.month || (now.month == picked.month && now.day < picked.day)) {
          age--;
        }
        widget.formData.age = age;
      });
      widget.onStateChanged();
    }
  }

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
            title: 'Personal Information',
            description: 'Enter your legal identity details as per official documents.',
          ),
          const SizedBox(height: 20),

          // First Name & Last Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextInput(
                  controller: _firstNameController,
                  label: 'First Name *',
                  hint: 'e.g. Alex',
                  prefixIcon: Icons.badge_outlined,
                  validator: FormValidators.validateFirstName,
                  onChanged: (val) {
                    widget.formData.firstName = val.trim();
                    widget.onStateChanged();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomTextInput(
                  controller: _lastNameController,
                  label: 'Last Name *',
                  hint: 'e.g. Morgan',
                  prefixIcon: Icons.person_outline,
                  validator: FormValidators.validateLastName,
                  onChanged: (val) {
                    widget.formData.lastName = val.trim();
                    widget.onStateChanged();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gender selection
          Text(
            'Gender *',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: ['Male', 'Female', 'Other'].map((gender) {
              final isSelected = widget.formData.gender == gender;
              return ChoiceChip(
                label: Text(gender),
                selected: isSelected,
                avatar: Icon(
                  gender == 'Male'
                      ? Icons.male_rounded
                      : (gender == 'Female'
                          ? Icons.female_rounded
                          : Icons.transgender_rounded),
                  size: 18,
                  color: isSelected ? theme.colorScheme.onPrimary : null,
                ),
                selectedColor: theme.colorScheme.primary,
                labelStyle: TextStyle(
                  color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => widget.formData.gender = gender);
                    widget.onStateChanged();
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Date of Birth & Calculated Age Field
          FormField<DateTime>(
            initialValue: widget.formData.birthDate,
            validator: (val) => FormValidators.validateBirthDate(widget.formData.birthDate),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date of Birth *',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      await _selectDate(context);
                      state.didChange(widget.formData.birthDate);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: state.hasError
                              ? theme.colorScheme.error
                              : theme.colorScheme.outline.withValues(alpha: 0.3),
                          width: state.hasError ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: widget.formData.birthDate == null
                                ? Text(
                                    'Select your birth date',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.7),
                                    ),
                                  )
                                : Text(
                                    '${widget.formData.formattedBirthDate} (${widget.formData.age} years old)',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
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
          ),
          const SizedBox(height: 16),

          // National ID / Student ID
          CustomTextInput(
            controller: _idController,
            label: 'National ID / Student ID *',
            hint: 'e.g. CSE-2026-464 or 1998273645',
            prefixIcon: Icons.badge_rounded,
            validator: FormValidators.validateIdNumber,
            helperText: 'Official identifier for enrollment records',
            onChanged: (val) {
              widget.formData.idNumber = val.trim();
              widget.onStateChanged();
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
              child: Icon(Icons.person_pin_rounded, color: theme.colorScheme.primary, size: 22),
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
