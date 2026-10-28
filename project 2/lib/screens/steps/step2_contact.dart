import 'package:flutter/material.dart';
import '../../models/wizard_form_data.dart';
import '../../utils/form_validators.dart';
import '../../widgets/custom_text_input.dart';

/// Step 2: Contact Details
class Step2Contact extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final WizardFormData formData;
  final VoidCallback onStateChanged;

  const Step2Contact({
    super.key,
    required this.formKey,
    required this.formData,
    required this.onStateChanged,
  });

  @override
  State<Step2Contact> createState() => _Step2ContactState();
}

class _Step2ContactState extends State<Step2Contact> {
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _postalController;

  static const List<String> _countries = [
    'Bangladesh',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'Japan',
    'Singapore',
    'India',
    'Malaysia',
    'United Arab Emirates',
  ];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.formData.email);
    _phoneController = TextEditingController(text: widget.formData.phone);
    _addressController = TextEditingController(text: widget.formData.streetAddress);
    _cityController = TextEditingController(text: widget.formData.city);
    _postalController = TextEditingController(text: widget.formData.postalCode);
  }

  @override
  void didUpdateWidget(covariant Step2Contact oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.formData.email != _emailController.text) {
      _emailController.text = widget.formData.email;
    }
    if (widget.formData.phone != _phoneController.text) {
      _phoneController.text = widget.formData.phone;
    }
    if (widget.formData.streetAddress != _addressController.text) {
      _addressController.text = widget.formData.streetAddress;
    }
    if (widget.formData.city != _cityController.text) {
      _cityController.text = widget.formData.city;
    }
    if (widget.formData.postalCode != _postalController.text) {
      _postalController.text = widget.formData.postalCode;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
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
            title: 'Contact Details',
            description: 'Provide reliable contact channels and residential address.',
          ),
          const SizedBox(height: 20),

          // Email Address
          CustomTextInput(
            controller: _emailController,
            label: 'Email Address *',
            hint: 'e.g. alex.morgan@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
            onChanged: (val) {
              widget.formData.email = val.trim();
              widget.onStateChanged();
            },
          ),
          const SizedBox(height: 16),

          // Phone Number
          CustomTextInput(
            controller: _phoneController,
            label: 'Phone Number *',
            hint: 'e.g. +8801700000000 or 01700000000',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: FormValidators.validatePhone,
            helperText: 'Used for important notifications and verification',
            onChanged: (val) {
              widget.formData.phone = val.trim();
              widget.onStateChanged();
            },
          ),
          const SizedBox(height: 16),

          // Street Address
          CustomTextInput(
            controller: _addressController,
            label: 'Street Address *',
            hint: 'e.g. Apt 4B, 124 University Avenue',
            prefixIcon: Icons.home_outlined,
            validator: FormValidators.validateStreetAddress,
            onChanged: (val) {
              widget.formData.streetAddress = val.trim();
              widget.onStateChanged();
            },
          ),
          const SizedBox(height: 16),

          // City & Postal Code
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: CustomTextInput(
                  controller: _cityController,
                  label: 'City *',
                  hint: 'e.g. Dhaka',
                  prefixIcon: Icons.location_city_rounded,
                  validator: FormValidators.validateCity,
                  onChanged: (val) {
                    widget.formData.city = val.trim();
                    widget.onStateChanged();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: CustomTextInput(
                  controller: _postalController,
                  label: 'Postal Code *',
                  hint: 'e.g. 1205',
                  prefixIcon: Icons.mark_as_unread_outlined,
                  validator: FormValidators.validatePostalCode,
                  onChanged: (val) {
                    widget.formData.postalCode = val.trim();
                    widget.onStateChanged();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Country Selector
          Text(
            'Country *',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: _countries.contains(widget.formData.country)
                ? widget.formData.country
                : _countries.first,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.public_rounded, size: 20),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
            ),
            items: _countries.map((c) {
              return DropdownMenuItem(value: c, child: Text(c));
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => widget.formData.country = val);
                widget.onStateChanged();
              }
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
              child: Icon(Icons.contact_phone_rounded,
                  color: theme.colorScheme.primary, size: 22),
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
