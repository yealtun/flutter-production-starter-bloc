import 'package:flutter/material.dart';
import '../../../../core/logging/app_logger.dart';
import '../../data/sdk_wrapper.dart';

/// SDK demo screen
class SdkDemoScreen extends StatefulWidget {
  const SdkDemoScreen(
      {super.key, required this.sdkWrapper, required this.logger});

  final SdkWrapper sdkWrapper;
  final AppLogger logger;

  @override
  State<SdkDemoScreen> createState() => _SdkDemoScreenState();
}

class _SdkDemoScreenState extends State<SdkDemoScreen> {
  bool _isInitialized = false;
  bool _isLoading = false;
  String _status = 'Not initialized';

  Future<void> _initSdk() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing...';
    });

    try {
      await widget.sdkWrapper.init();
      setState(() {
        _isInitialized = true;
        _status = 'Initialized';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _trackEvent() async {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please initialize SDK first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _status = 'Tracking event...';
    });

    try {
      await widget.sdkWrapper.trackEvent(
        'button_clicked',
        properties: {'screen': 'sdk_demo'},
      );
      setState(() {
        _status = 'Event tracked successfully';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SDK Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    if (_isLoading) ...[
                      const SizedBox(height: 16),
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _initSdk,
              child: const Text('Initialize SDK'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading || !_isInitialized ? null : _trackEvent,
              child: const Text('Track Event'),
            ),
          ],
        ),
      ),
    );
  }
}
