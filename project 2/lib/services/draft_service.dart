import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/wizard_form_data.dart';

/// Service responsible for persisting and restoring wizard draft data
class DraftService {
  // In-memory cache ensures zero native-dependency failure across web & all platforms
  static WizardFormData? _inMemoryDraft;
  static const String _draftFileName = '.wizard_form_draft.json';

  /// Saves the current form state as a draft with timestamp
  static Future<void> saveDraft(WizardFormData data) async {
    data.draftSavedAt = DateTime.now();
    _inMemoryDraft = data.copy();

    // On desktop/mobile platforms, optionally save to local storage file
    if (!kIsWeb) {
      try {
        final file = File(_draftFileName);
        await file.writeAsString(data.toJsonString());
      } catch (e) {
        debugPrint('File write draft fallback: $e');
      }
    }
  }

  /// Retrieves the saved draft, if any
  static Future<WizardFormData?> loadDraft() async {
    if (_inMemoryDraft != null) {
      return _inMemoryDraft!.copy();
    }

    if (!kIsWeb) {
      try {
        final file = File(_draftFileName);
        if (await file.exists()) {
          final content = await file.readAsString();
          final parsed = WizardFormData.fromJsonString(content);
          if (parsed != null) {
            _inMemoryDraft = parsed;
            return parsed.copy();
          }
        }
      } catch (e) {
        debugPrint('File read draft error: $e');
      }
    }

    return null;
  }

  /// Checks if an active draft exists
  static Future<bool> hasDraft() async {
    if (_inMemoryDraft != null) return true;
    if (!kIsWeb) {
      try {
        final file = File(_draftFileName);
        return await file.exists();
      } catch (_) {}
    }
    return false;
  }

  /// Removes the draft once submitted or intentionally discarded
  static Future<void> clearDraft() async {
    _inMemoryDraft = null;
    if (!kIsWeb) {
      try {
        final file = File(_draftFileName);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
    }
  }

  /// Formats the draft saved timestamp nicely for UI display
  static String formatTimestamp(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second $period';
  }
}
