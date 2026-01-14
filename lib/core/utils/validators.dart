/// Validates an email address format
bool isValidEmail(String email) {
  if (email.isEmpty) return false;
  // ignore: deprecated_member_use
  // RegExp is still the standard way to validate email patterns
  // The deprecation warning is about future final class, not current usage
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

/// Validates a password strength
/// Returns `true` if password meets minimum requirements:
/// - At least 8 characters
/// - Contains at least one letter
/// - Contains at least one number
bool isValidPassword(String password) {
  if (password.length < 8) return false;
  // ignore: deprecated_member_use
  // RegExp is still the standard way to validate patterns
  // The deprecation warning is about future final class, not current usage
  if (!password.contains(RegExp(r'[a-zA-Z]'))) return false;
  if (!password.contains(RegExp(r'[0-9]'))) return false;
  return true;
}

/// Validates that a string is not empty
bool isNotEmpty(String? value) {
  return value != null && value.trim().isNotEmpty;
}

/// Validates that a string has a minimum length
bool hasMinLength(String value, int minLength) {
  return value.length >= minLength;
}

/// Validates that a string has a maximum length
bool hasMaxLength(String value, int maxLength) {
  return value.length <= maxLength;
}
