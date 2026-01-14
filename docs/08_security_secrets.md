# Security & Secrets

## Overview

This document covers security practices, secret management, and secure storage options.

## Secret Management

### Environment Variables

Use `--dart-define` for configuration:

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

### Never Commit Secrets

**Strictly Prohibited**:
- API keys
- Passwords
- Tokens
- Private keys
- Database credentials

### .gitignore

Ensure `.env` files are in `.gitignore`:

```
.env
.env.local
.env.*.local
```

## Token Storage

### Storage Abstraction

Use `LocalStorage` interface for storage operations:

```dart
abstract class LocalStorage {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  // ...
}
```

### Secure Storage Option

For sensitive data, use `flutter_secure_storage`:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage implements LocalStorage {
  final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @override
  Future<void> saveString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }
}
```

### When to Use Secure Storage

- Access tokens
- Refresh tokens
- API keys
- User credentials
- Sensitive user data

### When SharedPreferences is OK

- User preferences
- Feature flags
- Non-sensitive settings
- Cache data

## Best Practices

### 1. Least Privilege

- Request only necessary permissions
- Don't request permissions you don't use
- Document why each permission is needed

### 2. No PII in Logs

- Sanitize logs automatically
- Never log passwords, tokens, or secrets
- Use request IDs for tracing instead of user data

### 3. Input Validation

- Validate all user inputs
- Sanitize data before sending to API
- Use type-safe models

### 4. HTTPS Only

- Always use HTTPS for API calls
- Never send sensitive data over HTTP
- Validate SSL certificates

### 5. Token Management

- Store tokens securely
- Implement token refresh
- Clear tokens on logout
- Handle token expiration

## Security Checklist

- [ ] No secrets in code
- [ ] Environment variables for config
- [ ] Secure storage for tokens
- [ ] HTTPS for all API calls
- [ ] Input validation
- [ ] No PII in logs
- [ ] Least privilege permissions
- [ ] Regular dependency updates

## Dependency Security

### Regular Updates

Keep dependencies updated:

```bash
fvm flutter pub outdated
fvm flutter pub upgrade
```

### Vulnerability Scanning

- Use `flutter pub audit` (when available)
- Monitor security advisories
- Update vulnerable dependencies promptly

## Production Security

### Code Obfuscation

For release builds:

```bash
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

### Certificate Pinning

Consider certificate pinning for production:

```dart
final dio = Dio();
(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
  client.badCertificateCallback = (cert, host, port) {
    // Implement certificate pinning
    return false;
  };
  return client;
};
```
