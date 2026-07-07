import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobo_crm/utils/globals.dart';
import '../../utils/location_helper.dart';
import '../../utils/snackbar.dart';

/// A screen that allows the user to select and confirm a geographic location.
///
/// Features:
/// - Fetches and displays the user's current location
/// - Converts coordinates into a readable address
/// - Allows selecting between current and previously saved location
/// - Supports returning selected coordinates via callback or Navigator result
/// - Provides option to open selected location in Google Maps
///
/// Parameters:
/// - [initialLatitude] Optional pre-filled latitude
/// - [initialLongitude] Optional pre-filled longitude
/// - [onLocationSelected] Callback triggered when location is confirmed
///
/// Returns:
/// Navigator.pop(context, {
///   'latitude': double,
///   'longitude': double,
///   'address': String?
/// });
class SelectLocationScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final Function(double latitude, double longitude)? onLocationSelected;

  const SelectLocationScreen({
    Key? key,
    this.initialLatitude,
    this.initialLongitude,
    this.onLocationSelected,
  }) : super(key: key);

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

/// State class for [SelectLocationScreen].
///
/// Responsibilities:
/// - Fetching current GPS location
/// - Managing selected vs current coordinates
/// - Reverse geocoding coordinates into address
/// - Handling loading, error, and saving states
/// - Confirming and returning selected location
class _SelectLocationScreenState extends State<SelectLocationScreen> {
  double? _selectedLatitude;
  double? _selectedLongitude;
  double? _currentLatitude;
  double? _currentLongitude;
  String? _selectedAddress;
  String? _currentAddress;
  bool _isLoading = true;
  bool _isGettingAddress = false;
  String? _errorMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  /// Initializes location when the screen loads.
  ///
  /// Logic:
  /// - If initial coordinates are provided → use them
  /// - Otherwise → fetch current device location
  /// - Resolves address from coordinates
  /// - Handles loading and error states
  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      setState(() {
        _selectedLatitude = widget.initialLatitude;
        _selectedLongitude = widget.initialLongitude;
        _currentLatitude = widget.initialLatitude;
        _currentLongitude = widget.initialLongitude;
      });
      await _getAddressForCoordinates(_selectedLatitude!, _selectedLongitude!);
    } else {
      await _getCurrentLocation();
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// Fetches the user's current GPS location.
  ///
  /// Uses [LocationHelper.getCurrentLocation].
  ///
  /// Updates:
  /// - _currentLatitude
  /// - _currentLongitude
  /// - _selectedLatitude (if not already set)
  /// - _selectedLongitude (if not already set)
  ///
  /// Handles permission errors and failures gracefully.
  Future<void> _getCurrentLocation() async {
    try {
      Position? position = await LocationHelper.getCurrentLocation();

      if (position != null) {
        setState(() {
          _currentLatitude = position.latitude;
          _currentLongitude = position.longitude;
          if (_selectedLatitude == null && _selectedLongitude == null) {
            _selectedLatitude = position.latitude;
            _selectedLongitude = position.longitude;
          }
        });

        await _getAddressForCoordinates(position.latitude, position.longitude);
      } else {
        setState(() {
          _errorMessage =
              'Unable to get current location. Please check location permissions.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: ${e.toString()}';
      });
    }
  }

  /// Converts latitude and longitude into a readable address
  /// using reverse geocoding.
  ///
  /// Parameters:
  /// - [latitude]
  /// - [longitude]
  ///
  /// Updates:
  /// - _selectedAddress (if matching selected coordinates)
  /// - _currentAddress (if matching current coordinates)
  ///
  /// Shows address loading indicator while fetching.
  Future<void> _getAddressForCoordinates(
      double latitude, double longitude) async {
    setState(() {
      _isGettingAddress = true;
    });

    try {
      String? address =
          await LocationHelper.getAddressFromCoordinates(latitude, longitude);
      setState(() {
        if (_selectedLatitude == latitude && _selectedLongitude == longitude) {
          _selectedAddress = address ?? 'Address not found';
        }
        if (_currentLatitude == latitude && _currentLongitude == longitude) {
          _currentAddress = address ?? 'Address not found';
        }
      });
    } catch (_) {
    } finally {
      setState(() {
        _isGettingAddress = false;
      });
    }
  }

  /// Confirms the selected location.
  ///
  /// Actions:
  /// - Triggers [onLocationSelected] callback (if provided)
  /// - Returns selected data via Navigator.pop
  /// - Shows saving state while processing
  /// - Displays error snackbar on failure
  Future<void> _confirmLocation() async {
    if (_selectedLatitude == null || _selectedLongitude == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (widget.onLocationSelected != null) {
        widget.onLocationSelected!(_selectedLatitude!, _selectedLongitude!);
      }

      if (mounted) {
        Navigator.pop(context, {
          'latitude': _selectedLatitude,
          'longitude': _selectedLongitude,
          'address': _selectedAddress,
        });
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
            context, 'Error saving location: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  /// Sets the selected location to the user's current GPS location.
  ///
  /// Refreshes:
  /// - Selected coordinates
  /// - Selected address
  ///
  /// Triggers loading state during update.
  Future<void> _useCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    await _getCurrentLocation();

    if (_currentLatitude != null && _currentLongitude != null) {
      setState(() {
        _selectedLatitude = _currentLatitude;
        _selectedLongitude = _currentLongitude;
        _selectedAddress = _currentAddress;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// Displays a help dialog explaining how location selection works.
  ///
  /// Includes:
  /// - How to use current location
  /// - How location is saved
  /// - Google Maps viewing information
  void _showLocationHelp() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Text(
          'Location Help',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• Tap "Use Current Location" to get your current position',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• The selected location will be saved to the customer record',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• You can view the location on Google Maps later',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: TextStyle(
                color: const Color(0xFFD32F2F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Select Location',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showLocationHelp,
            tooltip: 'Help',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState(isDark)
          : _errorMessage != null
              ? _buildErrorState(isDark)
              : _buildLocationContent(isDark),
      floatingActionButton:
          _selectedLatitude != null && _selectedLongitude != null
              ? FloatingActionButton.extended(
                  onPressed: _isSaving ? null : _confirmLocation,
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  highlightElevation: 0,
                  focusElevation: 0,
                  hoverElevation: 0,
                  disabledElevation: 0,
                  label: _isSaving
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Saving...',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Confirm Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  icon: _isSaving ? null : const Icon(Icons.check),
                )
              : null,
    );
  }

  /// Builds the loading UI shown while:
  /// - Fetching GPS coordinates
  /// - Initializing location
  ///
  /// Displays animated loading indicator and message.
  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.fourRotatingDots(
            color: const Color(0xFFD32F2F),
            size: 50,
          ),
          const SizedBox(height: 24),
          Text(
            'Getting your location...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we fetch your current location.',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the error UI shown when:
  /// - Location permission denied
  /// - GPS fetch fails
  ///
  /// Includes retry button to reinitialize location.
  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Location Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializeLocation,
              icon: const Icon(Icons.refresh),
              label: Text(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main content displaying:
  /// - Current location card
  /// - Selected location card
  /// - Use current location button
  ///
  /// Allows user to switch between locations.
  Widget _buildLocationContent(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentLatitude != null && _currentLongitude != null)
            _buildLocationCard(
              title: 'Current Location',
              latitude: _currentLatitude!,
              longitude: _currentLongitude!,
              address: _currentAddress,
              icon: Icons.my_location,
              iconColor: Colors.blue,
              isDark: isDark,
              isSelected: _selectedLatitude == _currentLatitude &&
                  _selectedLongitude == _currentLongitude,
              onTap: () {
                setState(() {
                  _selectedLatitude = _currentLatitude;
                  _selectedLongitude = _currentLongitude;
                  _selectedAddress = _currentAddress;
                });
              },
            ),
          const SizedBox(height: 16),
          if (_selectedLatitude != null && _selectedLongitude != null)
            _buildLocationCard(
              title: 'Selected Location',
              latitude: _selectedLatitude!,
              longitude: _selectedLongitude!,
              address: _selectedAddress,
              icon: Icons.location_on,
              iconColor: const Color(0xFFD32F2F),
              isDark: isDark,
              isSelected: true,
              showViewOnMap: true,
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _useCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: Text(
                    'Use Current Location',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a styled location information card.
  ///
  /// Parameters:
  /// - [title] Section title
  /// - [latitude] Location latitude
  /// - [longitude] Location longitude
  /// - [address] Optional resolved address
  /// - [icon] Leading icon
  /// - [iconColor] Icon highlight color
  /// - [isDark] Theme flag
  /// - [isSelected] Whether this location is selected
  /// - [showViewOnMap] Whether to show "View on Google Maps" button
  /// - [onTap] Optional tap handler
  ///
  /// Used for displaying both current and selected locations.
  Widget _buildLocationCard({
    required String title,
    required double latitude,
    required double longitude,
    String? address,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
    bool isSelected = false,
    bool showViewOnMap = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isSelected
            ? Border.all(color: const Color(0xFFD32F2F), width: 2)
            : Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: iconColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD32F2F).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Selected',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD32F2F),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Coordinates: ${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                if (address != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (showViewOnMap) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => LocationHelper.launchGoogleMaps(
                          context, latitude, longitude),
                      icon: const Icon(Icons.map, size: 16),
                      label: Text(
                        'View on Google Maps',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD32F2F),
                        side: const BorderSide(
                            color: Color(0xFFD32F2F), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
