# Release Checklist

## Pre-Release

### Code Quality
- [ ] All tests passing
- [ ] Code formatted (`dart format .`)
- [ ] Static analysis clean (`flutter analyze`)
- [ ] No TODOs or FIXMEs in code
- [ ] Documentation updated

### Versioning

Follow **Semantic Versioning** (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

Update version in `pubspec.yaml`:

```yaml
version: 1.2.3+45
#           ^   ^
#           |   build number
#           version
```

### Git Tags

Tag releases:

```bash
git tag -a v1.2.3 -m "Release version 1.2.3"
git push origin v1.2.3
```

## Build Preparation

### Environment Variables

Ensure all required environment variables are set:
- `APP_ENV=prod`
- `API_BASE_URL=<production-url>`
- `AI_BASE_URL=<production-url>` (if applicable)

### Build Configuration

- [ ] Update app version
- [ ] Update build number
- [ ] Verify app name and bundle ID
- [ ] Check app icons and splash screens

## Android Release

### Pre-Build
- [ ] Update `versionCode` in `android/app/build.gradle.kts`
- [ ] Update `versionName` in `android/app/build.gradle.kts`
- [ ] Signing configuration verified
- [ ] ProGuard rules updated (if using)

### Build

```bash
fvm flutter build appbundle --release \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.example.com
```

### Post-Build
- [ ] Test APK/AAB on physical device
- [ ] Verify app signing
- [ ] Check app size
- [ ] Test all critical flows

### Play Store Submission

- [ ] Create release in Play Console
- [ ] Upload AAB
- [ ] Add release notes
- [ ] Set rollout percentage (if staged)
- [ ] Submit for review

## iOS Release

### Pre-Build
- [ ] Update version in `ios/Runner/Info.plist`
- [ ] Update build number
- [ ] Verify signing certificates
- [ ] Check provisioning profiles

### Build

```bash
fvm flutter build ipa --release \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.example.com
```

### Post-Build
- [ ] Test on physical device
- [ ] Verify app signing
- [ ] Check app size
- [ ] Test all critical flows

### App Store Submission

- [ ] Create version in App Store Connect
- [ ] Upload IPA
- [ ] Add release notes
- [ ] Set up TestFlight (if needed)
- [ ] Submit for review

## Post-Release

### Monitoring
- [ ] Monitor crash reports
- [ ] Check analytics for errors
- [ ] Monitor API error rates
- [ ] Track user feedback

### Rollback Plan
- [ ] Document rollback procedure
- [ ] Keep previous version available
- [ ] Monitor for critical issues

## Versioning Notes

### Semantic Versioning

- **1.0.0**: Initial release
- **1.0.1**: Bug fix
- **1.1.0**: New feature
- **2.0.0**: Breaking changes

### Build Numbers

- Increment with each build
- Used for app store submission
- Must be unique and increasing

### Git Tags

Tag format: `v{MAJOR}.{MINOR}.{PATCH}`

Example: `v1.2.3`

## Checklist Summary

### Code
- [ ] Tests passing
- [ ] Code formatted
- [ ] No linter errors
- [ ] Documentation updated

### Version
- [ ] Version updated in pubspec.yaml
- [ ] Build number incremented
- [ ] Git tag created

### Build
- [ ] Release build successful
- [ ] Tested on device
- [ ] App signing verified

### Submission
- [ ] Uploaded to store
- [ ] Release notes added
- [ ] Submitted for review

### Post-Release
- [ ] Monitoring active
- [ ] Rollback plan ready
