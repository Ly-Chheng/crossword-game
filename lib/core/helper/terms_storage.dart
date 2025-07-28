import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class TermsStorage {
  static const String _termsAcceptedKey = 'terms_accepted';
  static const String _termsVersionKey = 'terms_version';
  static const String _currentTermsVersion = '1.0'; // Update this when terms change

  /// Store terms acceptance status
  static Future<void> storeTermsAcceptance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_termsAcceptedKey, true);
      await prefs.setString(_termsVersionKey, _currentTermsVersion);
    } catch (e) {
      // Handle error - could log or show error message
      log('Error storing terms acceptance: $e');
    }
  }

  /// Check if terms have been accepted for current version
  static Future<bool> hasAcceptedTerms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAccepted = prefs.getBool(_termsAcceptedKey) ?? false;
      final acceptedVersion = prefs.getString(_termsVersionKey) ?? '';
      
      // Check if terms are accepted AND version matches current version
      return isAccepted && acceptedVersion == _currentTermsVersion;
    } catch (e) {
      log('Error checking terms acceptance: $e');
      return false;
    }
  }

  /// Clear terms acceptance (useful for testing or when terms change)
  static Future<void> clearTermsAcceptance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_termsAcceptedKey);
      await prefs.remove(_termsVersionKey);
    } catch (e) {
      log('Error clearing terms acceptance: $e');
    }
  }

  /// Get the version of terms that were accepted
  static Future<String?> getAcceptedTermsVersion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_termsVersionKey);
    } catch (e) {
      log('Error getting accepted terms version: $e');
      return null;
    }
  }
}