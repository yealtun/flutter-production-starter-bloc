# Performance

## Overview

This document covers performance optimizations, Flutter DevTools workflow, and common performance issues.

## Applied Optimizations

### Const Constructors

Use `const` constructors wherever possible:

```dart
const Text('Hello')
const SizedBox(height: 16)
```

### ListView.builder

Use `ListView.builder` for long lists:

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

### BlocBuilder buildWhen

Optimize rebuilds with `buildWhen`:

```dart
BlocBuilder<FeedCubit, FeedState>(
  buildWhen: (previous, current) => previous != current,
  builder: (context, state) => ...,
)
```

### Widget Splitting

Split large widgets into smaller, focused widgets:

```dart
// Bad: Large widget
Widget build(BuildContext context) {
  return Column(
    children: [
      // 100 lines of widgets
    ],
  );
}

// Good: Split widgets
Widget build(BuildContext context) {
  return Column(
    children: [
      HeaderWidget(),
      ContentWidget(),
      FooterWidget(),
    ],
  );
}
```

## Flutter DevTools

### Performance Tab

1. **Open DevTools**: `flutter pub global activate devtools`
2. **Start App**: `flutter run --profile`
3. **Connect DevTools**: Open DevTools URL
4. **Performance Tab**: Monitor frame rendering

### Key Metrics

- **Frame Time**: Should be < 16ms for 60fps
- **Jank**: Frames taking > 16ms
- **Rebuild Count**: Number of widget rebuilds

### CPU Profiler

- Identify expensive operations
- Find hot spots in code
- Optimize slow functions

### Memory Profiler

- Monitor memory usage
- Detect memory leaks
- Track object allocation

## Common Jank Causes

### 1. Expensive Build Methods

**Problem**: Heavy computation in build()

**Solution**: Move computation outside build or use memoization

### 2. Unnecessary Rebuilds

**Problem**: Widgets rebuilding when state hasn't changed

**Solution**: Use `buildWhen` in BlocBuilder

### 3. Large Lists Without Builder

**Problem**: Creating all list items at once

**Solution**: Use `ListView.builder` or `GridView.builder`

### 4. Synchronous Operations

**Problem**: Blocking UI thread with sync operations

**Solution**: Use async/await or isolates

### 5. Image Loading

**Problem**: Loading images without caching

**Solution**: Use `cached_network_image` package

## Image Caching

### cached_network_image

For network images, use `cached_network_image`:

```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### Benefits

- Automatic caching
- Memory and disk cache
- Placeholder support
- Error handling

## Performance Checklist

- [ ] Use `const` constructors
- [ ] Use `ListView.builder` for lists
- [ ] Optimize `BlocBuilder` with `buildWhen`
- [ ] Split large widgets
- [ ] Cache network images
- [ ] Avoid expensive operations in build()
- [ ] Use async/await for I/O
- [ ] Profile with DevTools regularly

## Monitoring

### Performance Metrics

Track in production:
- Frame rendering time
- App startup time
- Screen transition time
- API response time
- Memory usage

### Tools

- Flutter DevTools
- Firebase Performance Monitoring
- Custom performance logging
