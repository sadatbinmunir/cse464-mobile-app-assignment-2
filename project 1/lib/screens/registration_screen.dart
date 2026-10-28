import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/country.dart';
import '../models/user_registration.dart';
import '../utils/validators.dart';
import '../widgets/birth_date_picker_field.dart';
import '../widgets/country_picker_field.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gender_selector.dart';
import '../widgets/interest_selector.dart';
import '../widgets/password_field.dart';
import '../widgets/registration_summary_dialog.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _nidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Selection state
  DateTime? _birthDate;
  Country? _selectedCountry;
  String? _selectedGender;
  List<String> _selectedInterests = [];
  bool _agreedToTerms = false;
  bool _showTermsError = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _nidController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Calculates age from birth date and updates the age controller automatically
  void _onBirthDateSelected(DateTime date) {
    setState(() {
      _birthDate = date;
      final now = DateTime.now();
      int calculatedAge = now.year - date.year;
      if (now.month < date.month || (now.month == date.month && now.day < date.day)) {
        calculatedAge--;
      }
      _ageController.text = calculatedAge.toString();
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _ageController.clear();
    _nidController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _birthDate = null;
      _selectedCountry = null;
      _selectedGender = null;
      _selectedInterests = [];
      _agreedToTerms = false;
      _showTermsError = false;
    });
  }

  Future<void> _submitForm() async {
    setState(() {
      _showTermsError = !_agreedToTerms;
    });

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || !_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text('Please correct the highlighted errors before submitting.'),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulated short network/processing delay for smooth UX
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    final user = UserRegistration(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      nid: _nidController.text.trim(),
      birthDate: _birthDate!,
      country: _selectedCountry!,
      gender: _selectedGender!,
      interests: List<String>.from(_selectedInterests),
      password: _passwordController.text,
    );

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => RegistrationSummaryDialog(
        user: user,
        onReset: _resetForm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Registration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset form',
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Form?'),
                  content: const Text('This will clear all entered information.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _resetForm();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Banner Card
                    _buildHeaderBanner(theme),
                    const SizedBox(height: 20),

                    // Section 1: Personal Information
                    _buildSectionCard(
                      theme: theme,
                      icon: Icons.person_outline_rounded,
                      title: 'Personal Information',
                      subtitle: 'Basic details and contact identifiers',
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          label: 'Full Name *',
                          hint: 'e.g. John Doe',
                          prefixIcon: Icons.badge_outlined,
                          validator: Validators.validateName,
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address *',
                          hint: 'e.g. john.doe@example.com',
                          prefixIcon: Icons.email_outlined,
                          validator: Validators.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _phoneController,
                          label: 'Phone Number *',
                          hint: 'e.g. +8801700000000 or 01700000000',
                          prefixIcon: Icons.phone_outlined,
                          validator: Validators.validatePhone,
                          keyboardType: TextInputType.phone,
                          helperText: 'Include country code or standard mobile digits',
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _nidController,
                          label: 'National ID (NID) *',
                          hint: 'e.g. 19901234567890 (10, 13, or 17 digits)',
                          prefixIcon: Icons.credit_card_rounded,
                          validator: Validators.validateNID,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: BirthDatePickerField(
                                selectedDate: _birthDate,
                                onDateSelected: _onBirthDateSelected,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                controller: _ageController,
                                label: 'Age *',
                                hint: 'Auto/Manual',
                                prefixIcon: Icons.cake_outlined,
                                validator: (val) =>
                                    Validators.validateAge(val, birthDate: _birthDate),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                helperText: 'Auto-syncs with DOB',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Demographics (Country & Gender)
                    _buildSectionCard(
                      theme: theme,
                      icon: Icons.public_rounded,
                      title: 'Demographics & Nationality',
                      subtitle: 'Geographic and personal profile settings',
                      children: [
                        CountryPickerField(
                          selectedCountry: _selectedCountry,
                          onCountrySelected: (c) => setState(() => _selectedCountry = c),
                        ),
                        const SizedBox(height: 16),
                        GenderSelector(
                          selectedGender: _selectedGender,
                          onGenderChanged: (g) => setState(() => _selectedGender = g),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Section 3: Password & Security
                    _buildSectionCard(
                      theme: theme,
                      icon: Icons.shield_outlined,
                      title: 'Account Security',
                      subtitle: 'Create a resilient master password',
                      children: [
                        PasswordSection(
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Section 4: Interests
                    _buildSectionCard(
                      theme: theme,
                      icon: Icons.interests_outlined,
                      title: 'Preferences & Interests',
                      subtitle: 'Choose at least one field you are passionate about',
                      children: [
                        InterestSelector(
                          selectedInterests: _selectedInterests,
                          onChanged: (list) => setState(() => _selectedInterests = list),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Section 5: Terms & Conditions Checkbox
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _showTermsError
                              ? theme.colorScheme.error
                              : theme.colorScheme.outline.withValues(alpha: 0.2),
                          width: _showTermsError ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                activeColor: theme.colorScheme.primary,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                onChanged: (val) {
                                  setState(() {
                                    _agreedToTerms = val ?? false;
                                    if (_agreedToTerms) _showTermsError = false;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'I agree to the ',
                                      style: theme.textTheme.bodyMedium,
                                      children: [
                                        TextSpan(
                                          text: 'Terms of Service',
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        const TextSpan(text: ' and acknowledge the '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        const TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_showTermsError) ...[
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Text(
                                'You must agree to the terms to proceed',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isSubmitting ? null : _resetForm,
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _isSubmitting ? null : _submitForm,
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.how_to_reg_rounded, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Register Now',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.app_registration_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Registration',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'CSE 464 Project 1 • Full Form Validation',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
