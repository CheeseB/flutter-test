import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapSampleWebView extends StatefulWidget {
  const MapSampleWebView({super.key});

  @override
  State<MapSampleWebView> createState() => _MapSampleWebViewState();
}

class _MapSampleWebViewState extends State<MapSampleWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('http://192.168.0.107:3000'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Example'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
