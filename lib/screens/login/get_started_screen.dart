import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/globals.dart';

/// A full-screen onboarding widget for first-time users.
///
/// Displays a series of slides with images, titles, and descriptions.
/// Includes a carousel slider with dots indicator and a "Get Started" button.
/// Supports responsive layouts for mobile, tablet, and desktop.
class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {

  /// Returns the appropriate image path based on platform.
  ///
  /// On iOS, uses the image with suffix `ios.jpg`. For other platforms, uses `.jpg`.
  ///
  /// [baseName] The base name of the image file (e.g., '1', '2', '3').
  String _getImagePath(String baseName) {
    if (Platform.isIOS) {
      return 'assets/${baseName}ios.jpg';
    }
    return 'assets/$baseName.jpg';
  }

  /// List of onboarding slides, each containing:
  /// - `image`: the path to the slide image
  /// - `title`: the slide title
  /// - `description`: the slide description
  late final List<Map<String, String>> onboardingData = [
    {
      'image': _getImagePath('CRM1'),
      'title': 'All Your Customers\nin One Place',
      'description': 'Manage leads, track follow-ups, and never miss an opportunity again — everything organized beautifully.',
    },
    {
      'image': _getImagePath('CRM2'),
      'title': 'Smart Pipeline &\nRevenue Forecast',
      'description': 'Visualize your sales pipeline and see exactly how much revenue is coming your way — month after month.',
    },
    {
      'image': _getImagePath('CRM3'),
      'title': 'Activities That\nActually Get Done',
      'description': 'Set reminders, schedule calls & meetings, and get notified before anything slips through the cracks.',
    },
  ];

  /// Tracks the currently visible slide index
  int currentIndex = 0;

  /// Marks the onboarding as seen in `SharedPreferences`.
  ///
  /// Saves a boolean key `hasSeenGetStarted` to prevent showing onboarding again.
  Future<void> _markGetStartedSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenGetStarted', true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final isSmallMobile = width < 400;
    final isTablet = width >= 600 && width < 1024;
    final isDesktop = width >= 1024;

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;

          if (isDesktop && isLandscape) {
            return Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildCarousel(
                    theme,
                    isDark,
                    constraints.maxHeight,
                    constraints.maxWidth * 0.55,
                    isDesktop: true,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth > 1400 ? 80 : 60,
                          vertical: 40,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: _buildContent(theme, isDark, isDesktop: true),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (isTablet || isDesktop) {
            return Column(
              children: [
                Expanded(
                  flex: 55,
                  child: _buildCarousel(
                    theme,
                    isDark,
                    constraints.maxHeight * 0.55,
                    constraints.maxWidth,
                    isDesktop: false,
                  ),
                ),
                Expanded(
                  flex: 45,
                  child: Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 32,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: _buildContent(theme, isDark, isDesktop: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Stack(
              children: [
                _buildCarousel(theme, isDark, height, width, isDesktop: false),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallMobile ? 24 : 40,
                      vertical: isSmallMobile ? 20 : 40,
                    ),
                    child: Column(
                      children: [
                        const Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildContent(theme, isDark, isDesktop: false),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  /// Builds the carousel slider for the onboarding images.
  ///
  /// [theme] Current theme data.
  /// [isDark] Whether the current theme is dark.
  /// [height] The height of the carousel container.
  /// [width] The width of the carousel container.
  /// [isDesktop] Whether the layout is desktop.
  Widget _buildCarousel(
      ThemeData theme,
      bool isDark,
      double height,
      double width, {
        required bool isDesktop,
      }) {
    return SizedBox(
      height: height,
      width: width,
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          enlargeCenterPage: false,
          viewportFraction: 1.0,
          onPageChanged: (index, reason) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        items: onboardingData.map((data) {
          return Container(
            width: width,
            height: height,
            color: AppStyle.primaryColor,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    data['image']!,
                    width: width,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Builds the content section of the onboarding, including:
  /// - Title
  /// - Description
  /// - Get Started button
  /// - Dots indicator
  ///
  /// [theme] Current theme data.
  /// [isDark] Whether the current theme is dark.
  /// [isDesktop] Whether the layout is desktop.
  Widget _buildContent(
      ThemeData theme,
      bool isDark, {
        required bool isDesktop,
      }) {
    final fontSize = isDesktop ? 24.0 : 28.0;
    final descSize = isDesktop ? 14.0 : 16.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          onboardingData[currentIndex]['title']!,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.3,
            letterSpacing: -0.5,
            shadows: const [
              Shadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Colors.black54,
              ),
            ],
          ),
        ),

        SizedBox(height: isDesktop ? 10 : 15),

        Text(
          onboardingData[currentIndex]['description']!,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: descSize,
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.6,
            letterSpacing: 0.1,
            shadows: const [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Colors.black54,
              ),
            ],
          ),
        ),

        SizedBox(height: isDesktop ? 30 : 40),

        SizedBox(
          width: double.infinity,
          height: isDesktop ? 45 : 55,
          child: ElevatedButton(
            onPressed: () async {
              await _markGetStartedSeen();
              if (context.mounted) {
                Navigator.pushReplacementNamed(
                    context, '/server_setup');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppStyle.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
              shadowColor: AppStyle.primaryColor.withValues(alpha: 0.3),
            ),
            child: Text(
              'Get Started',
              style: GoogleFonts.inter(
                fontSize: isDesktop ? 18 : 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),

        SizedBox(height: isDesktop ? 15 : 20),

        DotsIndicator(
          dotsCount: onboardingData.length,
          position: currentIndex.toDouble(),
          decorator: DotsDecorator(
            activeColor: Colors.white,
            color: Colors.white.withValues(alpha: 0.4),
            size: Size.square(isDesktop ? 6.0 : 8.0),
            activeSize: Size(isDesktop ? 12.0 : 16.0, isDesktop ? 6.0 : 8.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),

        SizedBox(height: isDesktop ? 10 : 20),
      ],
    );
  }
}
