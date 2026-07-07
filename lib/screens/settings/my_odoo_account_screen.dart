import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// A StatefulWidget that displays an Odoo login page inside an In-App WebView.
///
/// This widget allows users to open a specified Odoo server URL and handles
/// the full login flow, including loading indicators, error handling, and
/// page refresh functionality. It provides visual feedback while the page is
/// loading and shows a friendly error message when the connection fails. Users
/// can retry connecting or reload the page using built-in buttons.
///
/// Example usage:
/// ```dart
/// OdooLoginPage(
///   url: 'https://your-odoo-server.com/web/login',
///   title: 'Odoo Login',
/// )
/// ```
///
/// Features:
/// - Linear progress bar while page is loading.
/// - Circular progress indicator for initial load.
/// - Handles HTTP errors and load failures gracefully.
/// - Allows manual refresh and retry on connection errors.
class OdooLoginPage extends StatefulWidget {
  final String url;
  final String title;
  const OdooLoginPage({super.key, required this.url, required this.title});

  @override
  State<OdooLoginPage> createState() => _OdooLoginPageState();
}

class _OdooLoginPageState extends State<OdooLoginPage> {
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  late InAppWebViewController webViewController;
  double loadingProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
          actions: [
            if (!isLoading && !hasError)
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: _refreshWebView,
              ),
          ],
        ),
        body: Stack(
          children: [
            if (hasError)
              _buildErrorWidget()
            else
              Container(
                color: Colors.white,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    useShouldOverrideUrlLoading: true,
                    useOnLoadResource: true,
                    transparentBackground: true,
                    cacheEnabled: true,
                    clearCache: false,
                    supportZoom: true,
                    builtInZoomControls: false,
                    displayZoomControls: false,
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      isLoading = true;
                      hasError = false;
                      errorMessage = null;
                      loadingProgress = 0.0;
                    });
                  },
                  onProgressChanged: (controller, progress) {
                    setState(() {
                      loadingProgress = progress / 100.0;
                    });
                  },
                  onLoadStop: (controller, url) async {
                    setState(() {
                      isLoading = false;
                      loadingProgress = 1.0;
                    });

                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {
                          loadingProgress = 0.0;
                        });
                      }
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    setState(() {
                      isLoading = false;
                      hasError = true;
                      errorMessage = message;
                      loadingProgress = 0.0;
                    });
                  },
                  onLoadHttpError: (controller, url, statusCode, description) {
                    setState(() {
                      isLoading = false;
                      hasError = true;
                      errorMessage = 'HTTP Error $statusCode: $description';
                      loadingProgress = 0.0;
                    });
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    return NavigationActionPolicy.ALLOW;
                  },
                  onReceivedServerTrustAuthRequest: (controller, challenge) async {
                    return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED,
                    );
                  },
                ),
              ),

            if (loadingProgress > 0.0 && loadingProgress < 1.0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: loadingProgress,
                  backgroundColor: Colors.grey[200],
                  color: Theme.of(context).primaryColor,
                  minHeight: 3,
                ),
              ),

            if (isLoading && loadingProgress < 0.3)
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading Odoo...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please wait while we connect to your server',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'Connection Failed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Unable to connect to server',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _retryConnection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _retryConnection() {
    setState(() {
      hasError = false;
      errorMessage = null;
      isLoading = true;
    });

    if (webViewController != null) {
      webViewController.reload();
    }
  }

  void _refreshWebView() {
    if (webViewController != null) {
      webViewController.reload();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
