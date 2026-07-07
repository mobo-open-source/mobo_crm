import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:mobo_crm/screens/login/login.dart';
import 'package:mobo_crm/screens/login/login_layout.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/network_service.dart';

/// A screen that allows the user to configure the Odoo server connection.
///
/// This screen handles:
/// - Input of server URL with protocol selection (http / https)
/// - Fetching available databases from the server
/// - Providing URL history suggestions
/// - Manual database input if the server does not return any databases
/// - Validation and error handling for URL and database selection
///
/// Once the server URL and database are selected and validated,
/// it navigates to the [LoginPage].
///
/// Optional parameters:
/// - [serverUrl] — pre-filled server URL
/// - [database] — pre-selected database name
class ServerSetupScreen extends StatefulWidget {
  final String? serverUrl;
  final String? database;

  const ServerSetupScreen({
    super.key,
    this.database,
    this.serverUrl,
  });

  @override
  State<ServerSetupScreen> createState() => _ServerSetupScreenState();
}

/// State implementation for [ServerSetupScreen].
///
/// Responsibilities:
/// - Manages TextEditingControllers for server URL and manual database input
/// - Handles URL protocol selection (`http` / `https`)
/// - Maintains URL history and suggestions loaded from SharedPreferences
/// - Debounces user input to avoid excessive server requests
/// - Validates URLs and normalizes them
/// - Fetches database lists from the server using [NetworkService]
/// - Handles errors with user-friendly messages (_formatLoginError)
/// - Updates the UI to show dropdowns, manual input, loading state, and validation errors
/// - Determines whether the "Next" button should be enabled
///
/// Key private methods:
/// - [_loadUrlHistory] — Loads stored URL history and associated metadata
/// - [_setProtocol] — Updates the protocol and triggers validation
/// - [_isValidUrl] — Checks if the server URL is syntactically valid
/// - [_getUrlValidationError] — Returns error message if URL is invalid
/// - [_normalizeUrl] — Normalizes URL to include protocol and remove trailing slashes
/// - [_validateUrlAndFetchDatabases] — Fetches the database list and handles errors
/// - [_formatLoginError] — Maps exceptions to readable user-facing messages
///
/// The UI consists of:
/// - [LoginUrlTextField] for server URL input with history dropdown
/// - [LoginDropdownField] for database selection (if multiple databases found)
/// - [LoginManualDbInput] for manual database input
/// - [LoginErrorDisplay] for showing validation errors
/// - [LoginButton] to proceed to the login page
class _ServerSetupScreenState extends State<ServerSetupScreen> {
  final _urlController = TextEditingController();

  String _selectedProtocol = 'https://';
  String? _selectedDatabase;
  List<String> _databases = [];
  Map<String, Map<String, String>> _urlHistory = {};
  List<String> _urlSuggestions = [];
  bool _isLoading = false;
  bool _shouldValidate = false;
  bool _urlHasError = false;
  bool _dbHasError = false;
  String? _errorMessage;
  Timer? _debounceTimer;
  OdooClient? client;
  String? _workingProtocol;
  bool showError = false;
  final TextEditingController _manualDbController = TextEditingController();

  bool get _isNextButtonEnabled {
    final hasUrl = _urlController.text.trim().isNotEmpty;
    final hasValidState = _databases.isEmpty || _selectedDatabase != null;
    return hasUrl && hasValidState && !_isLoading;
  }

  @override
  void initState() {
    super.initState();
    _loadUrlHistory();
    if (widget.serverUrl != null && widget.serverUrl!.isNotEmpty) {
      final uri = Uri.tryParse(widget.serverUrl!);

      if (uri != null && uri.hasScheme) {
        _selectedProtocol = '${uri.scheme}://';
        _urlController.text =
            widget.serverUrl!.replaceFirst(RegExp(r'^https?://'), '');
      } else {
        _urlController.text = widget.serverUrl!;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _validateUrlAndFetchDatabases();
      });
    }

    if (widget.database != null && widget.database!.isNotEmpty) {
      _selectedDatabase = widget.database;
      _manualDbController.text = widget.database!;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadUrlHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final urls = prefs.getStringList('urlHistory') ?? [];
    _urlSuggestions.clear();
    _urlHistory.clear();
    for (String entry in urls) {
      try {
        final decoded = jsonDecode(entry);
        final url = decoded['url'] ?? '';
        final protocol = decoded['protocol'] ?? 'https://';
        final fullUrl = '$protocol$url';
        _urlSuggestions.add(fullUrl);
        _urlHistory[fullUrl] = {
          'db': decoded['db'] ?? '',
          'username': decoded['username'] ?? '',
        };
      } catch (_) {
        if (entry.isNotEmpty) {
          _urlSuggestions.add(entry);
          _urlHistory[entry] = {'db': '', 'username': '', 'password': ''};
        }
      }
    }
    _urlSuggestions = _urlSuggestions.toSet().toList();
    setState(() {});
  }

  void _setProtocol(String protocol) {
    setState(() {
      _selectedProtocol = protocol;
    });
    final trimmed = _urlController.text.trim();
    if (trimmed.isNotEmpty && _isValidUrl(trimmed)) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted) {
          _validateUrlAndFetchDatabases();
        }
      });
    }
  }

  bool _isValidUrl(String url) {
    try {
      String urlToValidate = url.trim();
      if (urlToValidate.isEmpty) return false;

      if (!urlToValidate.startsWith('http://') &&
          !urlToValidate.startsWith('https://')) {
        urlToValidate = '$_selectedProtocol$urlToValidate';
      }

      final uri = Uri.parse(urlToValidate);

      if (!uri.hasScheme || uri.host.isEmpty) {
        return false;
      }

      final host = uri.host.toLowerCase();
      if (host.contains(' ') || host.startsWith('.') || host.endsWith('.')) {
        return false;
      }

      final validHostPattern = RegExp(r'^[a-zA-Z0-9.-]+$');
      if (!validHostPattern.hasMatch(host)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  String? _getUrlValidationError(String url) {
    if (url.trim().isEmpty) {
      return null;
    }

    if (!_isValidUrl(url)) {
      return 'Please enter a valid server URL';
    }

    return null;
  }

  String _normalizeUrl(String input) {
    String url = input.trim();

    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }

    if (url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://')) {
      return url;
    }

    return '$_selectedProtocol$url';
  }

  Future<void> _validateUrlAndFetchDatabases() async {
    final rawUrl = _urlController.text.trim();

    if (rawUrl.isEmpty) {
      if (!mounted) return;
      setState(() {
        _databases.clear();
        _selectedDatabase = null;
        _errorMessage = null;
        _isLoading = false;
        _workingProtocol = null;
      });
      return;
    }

    if (!_isValidUrl(rawUrl)) {
      if (!mounted) return;
      setState(() {
        _databases.clear();
        _selectedDatabase = null;
        _errorMessage = 'Please enter a valid server URL';
        _isLoading = false;
        _workingProtocol = null;
      });
      return;
    }

    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _databases.clear();
      _selectedDatabase = null;
      _workingProtocol = null;
    });

    try {
      final match =
          RegExp(r'^(https?://)', caseSensitive: false).firstMatch(rawUrl);

      List<String> protocolsToTry = [];
      String host;

      if (match != null) {
        final detectedProtocol = match.group(1)!.toLowerCase();
        protocolsToTry = [detectedProtocol];
        host = rawUrl.substring(detectedProtocol.length);
      } else {
        host = rawUrl;
        protocolsToTry = [_selectedProtocol];
        protocolsToTry.add(
          _selectedProtocol == 'https://' ? 'http://' : 'https://',
        );
      }

      bool success = false;
      dynamic lastError;

      for (final protocol in protocolsToTry) {
        try {
          final baseUrl = _normalizeUrl('$protocol$host');

          final dbList =
              await NetworkService().fetchDatabaseList(baseUrl).timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );

          if (!mounted) return;

          if (dbList.isNotEmpty) {
            setState(() {
              _databases = dbList;
              _workingProtocol = protocol;
              _errorMessage = null;
              if (widget.database != null && dbList.contains(widget.database)) {
                _selectedDatabase = widget.database;
              } else if (dbList.length == 1) {
                _selectedDatabase = dbList.first;
              }
            });
          } else {
            setState(() {
              _databases = [];
              _workingProtocol = protocol;
              _manualDbController.text = widget.database ?? '';
              _errorMessage = 'Database listing is disabled (list_db=false). Cannot fetch databases automatically.';
            });
          }

          success = true;
          break;
        } catch (error) {
          if (error is Map && error.containsKey('data')) {
            if (!mounted) return;
            setState(() {
              _databases = [];
              _workingProtocol = protocol;
              _manualDbController.text = widget.database ?? '';
              _errorMessage = 'Database listing is disabled (list_db=false). Cannot fetch databases automatically.';
            });
            success = true;
            break;
          }
          lastError = error;
        }
      }

      if (!success && mounted) {
        setState(() {
          _databases.clear();
          _selectedDatabase = null;
          _workingProtocol = null;
          showError = true;
          _errorMessage = _formatLoginError(lastError);
        });
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _databases.clear();
        _selectedDatabase = null;
        _workingProtocol = null;
        showError = true;
        _errorMessage = _formatLoginError(error);
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatLoginError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('html instead of json') ||
        errorStr.contains('formatexception')) {
      return 'Server configuration issue. This may not be an Odoo server or the URL is incorrect.';
    } else if (errorStr.contains('invalid login') ||
        errorStr.contains('wrong credentials')) {
      return 'Incorrect email or password. Please check your login credentials.';
    } else if (errorStr.contains('user not found') ||
        errorStr.contains('no such user')) {
      return 'User account not found. Please check your email address or contact your administrator.';
    } else if (errorStr.contains('database') &&
        errorStr.contains('not found')) {
      return 'Selected database is not available. Please choose a different database.';
    } else if (errorStr.contains('network') || errorStr.contains('socket')) {
      return 'Network connection failed. Please check your internet connection.';
    } else if (errorStr.contains('timeout')) {
      return 'Connection timed out. The server may be slow or unreachable.';
    } else if (errorStr.contains('unauthorized') || errorStr.contains('403')) {
      return 'Access denied. Your account may not have permission to access this database.';
    } else if (errorStr.contains('server') || errorStr.contains('500')) {
      return 'Server error occurred. Please try again later or contact your administrator.';
    } else if (errorStr.contains('ssl') || errorStr.contains('certificate')) {
      return 'SSL connection failed. Try using HTTP instead of HTTPS.';
    } else if (errorStr.contains('connection refused')) {
      return 'Server is not responding. Please verify the server URL and try again.';
    } else if (errorStr.contains('connection terminated during handshake')) {
      return 'Secure connection failed. The server may not support HTTPS or has an invalid SSL certificate. Try switching to HTTP or contact your administrator.';
    } else {
      return 'Network error occurred. Please check your internet connection and server URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).pushReplacementNamed('/get_started');
        }
      },
      child: LoginLayout(
        title: 'Sign In',
        subtitle: 'Configure your server connection',
        child: _buildServerSetupForm(),
      ),
    );
  }

  Widget _buildServerSetupForm() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginUrlTextField(
            controller: _urlController,
            hint: 'Enter Server Address',
            prefixIcon: HugeIcons.strokeRoundedServerStack01,
            enabled: true,
            hasError: _urlHasError,
            selectedProtocol: _selectedProtocol,
            urlHistory: _urlSuggestions,
            isLoading: _isLoading,
            autovalidateMode: _shouldValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            validator: (value) {
              if (_isLoading || !_shouldValidate) {
                return null;
              }
              if (value == null || value.isEmpty) {
                return 'Server URL is required';
              }
              return null;
            },
            onProtocolChanged: _setProtocol,
            onChanged: (String rawValue) {
              _debounceTimer?.cancel();

              String value = rawValue.trim();

              String newProtocol = _selectedProtocol;

              if (value.toLowerCase().startsWith('https://')) {
                newProtocol = 'https://';
              } else if (value.toLowerCase().startsWith('http://')) {
                newProtocol = 'http://';
              }

              if (newProtocol != _selectedProtocol) {
                setState(() {
                  _selectedProtocol = newProtocol;
                });
              }

              setState(() {
                _shouldValidate = false;
                _urlHasError = false;
                _errorMessage = null;
                _databases.clear();
                _selectedDatabase = null;
                _isLoading = true;
              });

              final validationError = _getUrlValidationError(value);
              if (validationError != null) {
                setState(() {
                  _errorMessage = validationError;
                  _isLoading = false;
                });
                return;
              }

              _debounceTimer = Timer(const Duration(milliseconds: 700), () {
                if (!mounted) return;
                _validateUrlAndFetchDatabases();
              });
            },
            onHistorySelected: (selection) async {
              _debounceTimer?.cancel();

              final uri = Uri.tryParse(selection);

              if (uri != null && uri.hasScheme) {
                setState(() {
                  _selectedProtocol = '${uri.scheme}://';
                  _urlController.text =
                      selection.replaceFirst(RegExp(r'^https?://'), '');
                });
              }

              await _validateUrlAndFetchDatabases();

              if (_urlHistory.containsKey(selection)) {
                final entry = _urlHistory[selection]!;
                final historyDb = entry['db'];

                if (historyDb != null &&
                    historyDb.isNotEmpty &&
                    _databases.contains(historyDb)) {
                  setState(() {
                    _selectedDatabase = historyDb;
                  });
                }
              }
            },
          ),
          if (_databases.isNotEmpty) ...[
            const SizedBox(height: 16),
            LoginDropdownField(
              hint: _isLoading ? 'Loading...' : 'Select Database',
              value: _selectedDatabase,
              items: _databases,
              onChanged: _isLoading
                  ? null
                  : (String? newValue) {
                      setState(() {
                        _selectedDatabase = newValue;
                        _dbHasError = (newValue == null || newValue.isEmpty);
                        _errorMessage = null;
                      });
                    },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Database is required';
                }
                return null;
              },
              hasError: _dbHasError,
              autovalidateMode: _shouldValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
            ),
          ],
          if (_errorMessage != null) ...[
            SizedBox(
              height: 10,
            ),
            LoginErrorDisplay(error: _errorMessage),
            SizedBox(
              height: 10,
            ),
          ] else ...[
            SizedBox(
              height: 20,
            ),
          ],
          LoginButton(
              text: 'Next',
              isLoading: _isLoading,
              isEnabled: _isNextButtonEnabled,
              onPressed: (_databases.isEmpty || _selectedDatabase == null)
                  ? null
                  : () {
                      setState(() {
                        showError = true;
                      });
                      if (_errorMessage == null) {
                        var trimmedUrl = _urlController.text.trim();
                        trimmedUrl =
                            trimmedUrl.replaceFirst(RegExp(r'^https?://'), '');
                        String finalDb = _selectedDatabase!;
                        if (finalDb.isEmpty) {
                          setState(
                            () => _errorMessage = "Database name is required",
                          );
                          return;
                        }
                        setState(() {
                          _shouldValidate = false;
                          _urlHasError = false;
                          _errorMessage = null;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              protocol: _workingProtocol ?? _selectedProtocol,
                              serverUrl: trimmedUrl,
                              database: finalDb,
                            ),
                          ),
                        );
                      }
                    }),
        ],
      ),
    );
  }
}
