import 'package:flutter/material.dart';
import '../../data/ai_client.dart';

/// AI demo screen
class AiDemoScreen extends StatefulWidget {
  const AiDemoScreen({super.key, required this.aiClient});

  final AiClient aiClient;

  @override
  State<AiDemoScreen> createState() => _AiDemoScreenState();
}

class _AiDemoScreenState extends State<AiDemoScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _response;
  String? _error;

  Future<void> _callAi() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = null;
      _error = null;
    });

    try {
      final response = await widget.aiClient.callAiApi(_controller.text.trim());
      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter your prompt',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _callAi,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Call AI API'),
            ),
            if (_response != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Response:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_response!),
                    ],
                  ),
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Error:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
