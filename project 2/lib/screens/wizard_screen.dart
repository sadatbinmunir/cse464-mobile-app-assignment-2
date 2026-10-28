import 'package:flutter/material.dart';
import '../models/wizard_form_data.dart';
import '../services/draft_service.dart';
import '../widgets/step_progress_bar.dart';
import '../widgets/submission_success_dialog.dart';
import 'steps/step1_personal.dart';
import 'steps/step2_contact.dart';
import 'steps/step3_preferences.dart';
import 'steps/step4_review.dart';

/// Main Multi-Step Form Wizard Screen
class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  int _currentStep = 0;
  WizardFormData _formData = WizardFormData();
  bool _isFinalConfirmed = false;
  bool _isSubmitting = false;

  // Dedicated Form keys for independent step validation
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();
  final _step4Key = GlobalKey<FormState>();

  // Draft banner notification
  bool _showDraftBanner = false;
  String _draftBannerTime = '';

  @override
  void initState() {
    super.initState();
    _checkForExistingDraft();
  }

  Future<void> _checkForExistingDraft() async {
    final hasDraft = await DraftService.hasDraft();
    if (hasDraft) {
      final draft = await DraftService.loadDraft();
      if (draft != null && draft.draftSavedAt != null) {
        setState(() {
          _showDraftBanner = true;
          _draftBannerTime = DraftService.formatTimestamp(draft.draftSavedAt!);
        });
      }
    }
  }

  Future<void> _restoreDraft() async {
    final draft = await DraftService.loadDraft();
    if (draft != null) {
      setState(() {
        _formData = draft;
        _showDraftBanner = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.restore_page_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Draft restored successfully!'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveDraftManually() async {
    await DraftService.saveDraft(_formData);
    if (!mounted) return;
    final timeStr = DraftService.formatTimestamp(DateTime.now());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Draft saved successfully at $timeStr')),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetForm() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Wizard?'),
        content: const Text('All entered data and saved draft will be cleared.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await DraftService.clearDraft();
              setState(() {
                _formData = WizardFormData();
                _currentStep = 0;
                _isFinalConfirmed = false;
                _showDraftBanner = false;
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  /// Validates the current step before allowing navigation forward
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _step1Key.currentState?.validate() ?? false;
      case 1:
        return _step2Key.currentState?.validate() ?? false;
      case 2:
        return _step3Key.currentState?.validate() ?? false;
      case 3:
        return _step4Key.currentState?.validate() ?? false;
      default:
        return true;
    }
  }

  void _onNext() {
    if (!_validateCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Please correct the highlighted errors to proceed.')),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _submitForm();
    }
  }

  void _onBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _jumpToStep(int step) {
    setState(() => _currentStep = step);
  }

  Future<void> _submitForm() async {
    setState(() => _isSubmitting = true);

    // Realistic processing simulation
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    // Clear saved draft on successful final submission
    await DraftService.clearDraft();

    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => SubmissionSuccessDialog(
        formData: _formData,
        onStartNew: () {
          setState(() {
            _formData = WizardFormData();
            _currentStep = 0;
            _isFinalConfirmed = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Multi-Step Application Wizard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: 'Save Draft',
            onPressed: _saveDraftManually,
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded),
            tooltip: 'Reset Wizard',
            onPressed: _resetForm,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                // Unfinished Draft Found Alert Banner
                if (_showDraftBanner)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade400),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber.shade900),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Unfinished draft from $_draftBannerTime found.',
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _restoreDraft,
                          child: const Text('Restore', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() => _showDraftBanner = false),
                          tooltip: 'Dismiss',
                        ),
                      ],
                    ),
                  ),

                // Top Progress Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: StepProgressBar(
                    currentStep: _currentStep,
                    onStepTapped: _jumpToStep,
                  ),
                ),

                // Step Content Area (Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _buildCurrentStepWidget(),
                    ),
                  ),
                ),

                // Bottom Navigation & Actions Bar
                _buildBottomNavigationBar(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepWidget() {
    switch (_currentStep) {
      case 0:
        return Step1Personal(
          key: const ValueKey(0),
          formKey: _step1Key,
          formData: _formData,
          onStateChanged: () => setState(() {}),
        );
      case 1:
        return Step2Contact(
          key: const ValueKey(1),
          formKey: _step2Key,
          formData: _formData,
          onStateChanged: () => setState(() {}),
        );
      case 2:
        return Step3Preferences(
          key: const ValueKey(2),
          formKey: _step3Key,
          formData: _formData,
          onStateChanged: () => setState(() {}),
        );
      case 3:
        return Step4Review(
          key: const ValueKey(3),
          formKey: _step4Key,
          formData: _formData,
          onJumpToStep: _jumpToStep,
          isConfirmed: _isFinalConfirmed,
          onConfirmationChanged: (val) => setState(() => _isFinalConfirmed = val),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomNavigationBar(ThemeData theme) {
    final isFirstStep = _currentStep == 0;
    final isLastStep = _currentStep == 3;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.15))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          if (!isFirstStep)
            OutlinedButton.icon(
              onPressed: _isSubmitting ? null : _onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          if (!isFirstStep) const SizedBox(width: 12),

          // Save Draft Button
          TextButton.icon(
            onPressed: _isSubmitting ? null : _saveDraftManually,
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('Save Draft'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),

          const Spacer(),

          // Next / Submit Button
          ElevatedButton(
            onPressed: _isSubmitting ? null : _onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLastStep ? Colors.green.shade600 : theme.colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLastStep ? 'Submit Application' : 'Next Step',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isLastStep ? Icons.check_circle_outline_rounded : Icons.arrow_forward_rounded,
                        size: 18,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
