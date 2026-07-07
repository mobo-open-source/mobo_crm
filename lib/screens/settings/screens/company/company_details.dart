import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:mobo_crm/global_methods/widgets/shimmer/custom_shimmer.dart';
import 'package:mobo_crm/global_methods/services/global_error_handler.dart';
import 'package:mobo_crm/global_methods/widgets/transition/page_transition.dart';

import 'package:mobo_crm/global_methods/widgets/image_widget/full_screen_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/company/session/company_session_manager.dart';

/// A stateful widget that displays detailed company profile information.
///
/// Features:
/// - Loads company profile data from Odoo via [CompanySessionManager].
/// - Shows loading, error, or no data states appropriately.
/// - Displays company logo, name, VAT, contact info, and address in a modern card/grid layout.
class CompanyProfile extends StatefulWidget {
  final bool loadData;

  const CompanyProfile({super.key, this.loadData = false});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

/// State for [CompanyProfile].
class _CompanyProfileState extends State<CompanyProfile> {
  Map<String, dynamic> companyData = {};
  AppError? companyError;
  bool hasError = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompanyProfile();
  }

  /// Fetches company profile from Odoo using [CompanySessionManager].
  ///
  /// Sets [isLoading] true before fetching and handles:
  /// - Successful data fetch: populates [companyData].
  /// - Empty data: sets [companyData] to empty map.
  /// - Errors: sets [hasError] and [companyError] for display.
  Future<void> _fetchCompanyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('url') ?? '';

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      dynamic companyDetails;
      try {
        companyDetails = await CompanySessionManager.callKwWithCompany({
          'model': 'res.company',
          'method': 'search_read',
          'args': [[]],
          'kwargs': {
            'fields': [
              'name',
              'phone',
              'mobile',
              'email',
              'website',
              'street',
              'alias_domain_id',
              'city',
              'state_id',
              'country_id',
              'vat',
              'logo_web',
              'company_registry',
            ],
          },
        });
      } catch (e) {
        companyDetails = await CompanySessionManager.callKwWithCompany({
          'model': 'res.company',
          'method': 'search_read',
          'args': [[]],
          'kwargs': {
            'fields': [
              'name',
              'phone',
              'email',
              'website',
              'street',
              'alias_domain_id',
              'city',
              'state_id',
              'country_id',
              'vat',
              'logo_web',
              'company_registry',
            ],
          },
        });
      }

      if (companyDetails != null && companyDetails.isNotEmpty) {
        final company = companyDetails[0];
        company['address'] = _formatAddress(company);

        setState(() {
          companyData = company;
          isLoading = false;
        });
      } else {
        setState(() {
          companyData = {};
          isLoading = false;
        });
      }
    } catch (e) {
      Future.delayed(const Duration(seconds: 2), () async {
        companyError = await ErrorHandler.handleException(e, uri: url);

        setState(() {
          isLoading = false;
          hasError = true;
        });
      });
    }
  }

  /// Formats a complete address string from company data fields.
  ///
  /// Combines street, city, state, and country.
  /// Returns 'No Address' if all fields are empty.
  String _formatAddress(Map<String, dynamic> company) {
    List<String> addressParts = [];

    if (_getSafeStringValue(company['street']).isNotEmpty) {
      addressParts.add(_getSafeStringValue(company['street']));
    }
    if (_getSafeStringValue(company['city']).isNotEmpty) {
      addressParts.add(_getSafeStringValue(company['city']));
    }
    if (company['state_id'] is List && company['state_id'].length > 1) {
      addressParts.add(company['state_id'][1].toString());
    }
    if (company['country_id'] is List && company['country_id'].length > 1) {
      addressParts.add(company['country_id'][1].toString());
    }

    return addressParts.isNotEmpty ? addressParts.join(', ') : 'No Address';
  }

  /// Safely converts a dynamic value to string.
  ///
  /// Handles nulls, booleans, Strings, and List values.
  String _getSafeStringValue(dynamic value) {
    if (value == null || value == false) return '';
    if (value is String) return value;
    if (value is List && value.isNotEmpty) {
      return value.length > 1 ? value[1].toString() : value[0].toString();
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? ProfileShimmer(isCompany: true)
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.grey[50],
              title: Text(
                'Company Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                  fontSize: 20,
                ),
              ),
            ),
            backgroundColor: Colors.grey[50],
            body: hasError && companyError != null
                ? ErrorScreen(
                    error: companyError!,
                    onRetry: () {
                      _fetchCompanyProfile();
                    },
                  )
                : companyData.isEmpty
                    ? NoDataView()
                    : SingleChildScrollView(
                        child: CompanyContentView(
                          companyData: companyData,
                        ),
                      ));
  }
}

/// Displays the content of a company profile.
///
/// Includes:
/// - Company logo with tap-to-view full screen.
/// - Company name and VAT.
/// - Grid or column layout of company info like email, phone, website, and address.
class CompanyContentView extends StatelessWidget {
  final Map<String, dynamic> companyData;

  const CompanyContentView({super.key, required this.companyData});

  /// Safely converts a dynamic value to string.
  String _getSafeStringValue(dynamic value) {
    if (value == null || value == false) return '';
    if (value is String) return value;
    if (value is List && value.isNotEmpty) {
      return value.length > 1 ? value[1].toString() : value[0].toString();
    }
    return value.toString();
  }

  /// Builds the company logo widget.
  ///
  /// Handles:
  /// - Base64 images (PNG, JPG)
  /// - SVG images
  /// - Default placeholder with gradient if no logo available
  Widget _buildLogoWidget(BuildContext context) {
    final logoWeb = companyData['logo_web'];

    if (logoWeb == null || logoWeb == '' || logoWeb == 'false') {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF3B82F6),
              const Color(0xFF1D4ED8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.business_center_rounded,
          size: 50,
          color: Colors.white,
        ),
      );
    }

    try {
      final decodedBytes = base64Decode(logoWeb);
      final decodedString = utf8.decode(decodedBytes, allowMalformed: true);

      final decoration = BoxDecoration(
        shape: BoxShape.circle,
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      );
      if (decodedString.contains('<svg')) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              SlidingPageTransitionRL(
                  page: FullScreenImage.svg(svgString: decodedString)),
            );
          },
          child: Container(
            decoration: decoration,
            child: ClipOval(
              child: SvgPicture.string(
                decodedString,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                placeholderBuilder: (context) => const Icon(
                  Icons.business,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              SlidingPageTransitionRL(
                  page: FullScreenImage(
                imageProvider: MemoryImage(decodedBytes),
              )),
            );
          },
          child: Container(
            decoration: decoration,
            child: ClipOval(
              child: Image.memory(
                decodedBytes,
                height: 100,
                width: 100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.business,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              const Color(0xFFD32F2F),
              const Color(0xFFD32F2F).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.business,
          size: 40,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF1F2937),
                        const Color(0xFF111827),
                      ]
                    : [
                        const Color(0xFFFFFFFF),
                        const Color(0xFFF8FAFC),
                      ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  _buildLogoWidget(context),
                  const SizedBox(height: 24),
                  Text(
                    _getSafeStringValue(companyData['name']).isNotEmpty
                        ? _getSafeStringValue(companyData['name'])
                        : 'Company Name',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Business Organization',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_getSafeStringValue(companyData['vat']).isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'VAT: ${_getSafeStringValue(companyData['vat'])}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF3B82F6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoGrid(context, isDark, screenWidth),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  /// Builds a responsive grid/column for company information like email, phone, and address.
  Widget _buildInfoGrid(BuildContext context, bool isDark, double screenWidth) {
    final infoItems = <Map<String, dynamic>>[
      if (_getSafeStringValue(companyData['email']).isNotEmpty)
        {
          'icon': HugeIcons.strokeRoundedMail01,
          'title': 'Email Address',
          'value': _getSafeStringValue(companyData['email']),
          'color': const Color(0xFFEF4444),
        },
      if (_getSafeStringValue(companyData['phone']).isNotEmpty)
        {
          'icon': HugeIcons.strokeRoundedCall,
          'title': 'Phone Number',
          'value': _getSafeStringValue(companyData['phone']),
          'color': const Color(0xFF10B981),
        },
      if (_getSafeStringValue(companyData['mobile']).isNotEmpty)
        {
          'icon': HugeIcons.strokeRoundedSmartPhone01,
          'title': 'Mobile Number',
          'value': _getSafeStringValue(companyData['mobile']),
          'color': const Color(0xFF8B5CF6),
        },
      if (_getSafeStringValue(companyData['website']).isNotEmpty)
        {
          'icon': HugeIcons.strokeRoundedGlobe,
          'title': 'Website',
          'value': _getSafeStringValue(companyData['website']),
          'color': const Color(0xFF3B82F6),
        },
      {
        'icon': HugeIcons.strokeRoundedLocation01,
        'title': 'Address',
        'value': _getSafeStringValue(companyData['address']).isNotEmpty
            ? _getSafeStringValue(companyData['address'])
            : 'No Address Available',
        'color': const Color(0xFFF59E0B),
      },
      if (companyData['alias_domain_id'] is List &&
          companyData['alias_domain_id'].length > 1)
        {
          'icon': HugeIcons.strokeRoundedGlobe02,
          'title': 'Email Domain',
          'value': companyData['alias_domain_id'][1].toString(),
          'color': const Color(0xFF06B6D4),
        },
      if (_getSafeStringValue(companyData['company_registry']).isNotEmpty)
        {
          'icon': HugeIcons.strokeRoundedFile02,
          'title': 'Registry',
          'value': _getSafeStringValue(companyData['company_registry']),
          'color': const Color(0xFF84CC16),
        },
    ];

    if (screenWidth > 600) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: infoItems.length,
        itemBuilder: (context, index) {
          final item = infoItems[index];
          return _buildModernInfoCard(
            context: context,
            icon: item['icon'],
            title: item['title'],
            value: item['value'],
            color: item['color'],
            isDark: isDark,
          );
        },
      );
    } else {
      return Column(
        children: infoItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildModernInfoCard(
              context: context,
              icon: item['icon'],
              title: item['title'],
              value: item['value'],
              color: item['color'],
              isDark: isDark,
            ),
          );
        }).toList(),
      );
    }
  }

  /// Builds individual info cards for grid/column display.
  Widget _buildModernInfoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a loading indicator for company profile.
class CompanyLoadingView extends StatelessWidget {
  const CompanyLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: const Color(0xFFD32F2F),
          ),
          const SizedBox(height: 20),
          Text(
            "Loading company profile...",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows a view when no company data is available.
class NoDataView extends StatelessWidget {
  const NoDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFFD32F2F).withValues(alpha: 0.3),
                        const Color(0xFFD32F2F).withValues(alpha: 0.1)
                      ]
                    : [
                        const Color(0xFFD32F2F).withValues(alpha: 0.1),
                        const Color(0xFFD32F2F).withValues(alpha: 0.05)
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.business_center,
              size: 64,
              color: isDark
                  ? const Color(0xFFD32F2F).withValues(alpha: 0.8)
                  : const Color(0xFFD32F2F),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Company Data Found",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.grey[800],
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "We couldn't find any company information for your account",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
