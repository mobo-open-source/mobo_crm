import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../Rating/review_service.dart';

/// A fullscreen splash screen that plays a video when the app launches.
///
/// This widget initializes a local video asset and plays it in fullscreen mode
/// using [VideoPlayerController]. It hides the system UI for an immersive experience
/// and navigates automatically to the next screen (`/auth_check`) after the video
/// completes or if video initialization fails. The splash screen ensures smooth
/// transitions and handles device rotation and UI overlays gracefully.
///
/// Features:
/// - Plays a video asset in fullscreen with proper aspect ratio using FittedBox.
/// - Listens to video completion and navigates automatically.
/// - Uses immersive sticky mode to hide system UI during playback.
/// - Falls back gracefully to the next screen if video fails to load.
/// - Disposes resources correctly to prevent memory leaks.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  /// Tracks whether the splash video has already played this app session.
  ///
  /// On subsequent visits to the splash route (e.g. after logout), the video
  /// is not replayed — navigation happens immediately instead.
  static bool _hasPlayedOnce = false;

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

  /// Guards against navigating more than once. Both the video-completion
  /// listener and the fallback timer can attempt navigation; this ensures
  /// only the first one wins.
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        ReviewService().trackAppOpen();
      });
    });

    if (_hasPlayedOnce) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToNextScreen();
      });
      return;
    }
    _hasPlayedOnce = true;

    _initializeVideo();
  }

  /// Initializes the splash screen video from assets and starts playback.
  ///
  /// This method sets up the [VideoPlayerController] with the asset video
  /// 'assets/crmspash.mp4'. After successful initialization, it updates the
  /// state to indicate the video is ready, starts playback, and adds a listener
  /// to track video completion. If the video fails to load or initialize, it
  /// gracefully navigates to the next screen.
  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset('assets/crmspash.mp4');
      await _videoController!.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
        await _videoController!.play();
        _videoController!.addListener(_videoListener);

        Future.delayed(const Duration(seconds: 4), () {
          _navigateToNextScreen();
        });
      }
    } catch (e) {
      Future.delayed(const Duration(seconds: 1), () {
        _navigateToNextScreen();
      });
    }
  }

  /// Listener that monitors the video playback status.
  ///
  /// Checks if the video has reached its end. When the playback position
  /// equals or exceeds the total video duration, this method calls
  /// [_navigateToNextScreen] to transition the user to the next screen.
  /// This ensures the splash screen automatically completes after playback.
  void _videoListener() {
    if (_videoController != null &&
        _videoController!.value.position >= _videoController!.value.duration) {
      _navigateToNextScreen();
    }
  }

  /// Navigates to the authentication check screen after the splash.
  ///
  /// This method restores the system UI to edge-to-edge mode for normal
  /// app interaction and then pushes a replacement route to '/auth_check'.
  /// It ensures the splash screen is removed from the navigation stack
  /// to prevent users from returning to it.
  void _navigateToNextScreen() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Navigator.pushReplacementNamed(context, '/auth_check');
  }

  /// Disposes resources used by the splash screen.
  ///
  /// Removes the video listener and disposes the [VideoPlayerController]
  /// to free memory. Also restores system UI mode to edge-to-edge. This
  /// method is called automatically when the splash screen widget is removed
  /// from the widget tree to prevent memory leaks.
  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  /// Builds the splash screen widget tree.
  ///
  /// Displays the video in fullscreen using [FittedBox] to maintain
  /// aspect ratio. If the video is not yet initialized, it shows an empty
  /// widget. The background color is set to the app's primary color, providing
  /// a seamless transition while the video loads.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Theme.of(context).primaryColor),
          ),
          if (_isVideoInitialized && _videoController != null)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
