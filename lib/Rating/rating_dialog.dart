import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobo_crm/Rating/review_service.dart';

import '../utils/globals.dart';

/// A customizable rating dialog that allows users to rate the app
/// and optionally provide feedback.
///
/// If the user gives a rating of 4 stars or higher, the [onGoodReview]
/// callback is triggered. Typically, this is used to request an
/// in-app store review.
///
/// If the user gives a rating lower than 4 stars, the [onBadReview]
/// callback is triggered. This is generally used to collect feedback
/// via email and postpone future review prompts.
///
/// The dialog includes:
/// - A star rating bar (1–5 stars)
/// - An optional comment field (visible for ratings below 4)
/// - Continue button with rating display
/// - "Never Ask Again" and "Ask Me Later" actions
///
/// Use [CustomRatingDialog.show] to display the dialog.
class CustomRatingDialog extends StatefulWidget {
  final Function(double, String) onGoodReview;
  final Function(double, String) onBadReview;

  const CustomRatingDialog({
    Key? key,
    required this.onGoodReview,
    required this.onBadReview,
  }) : super(key: key);

  @override
  _CustomRatingDialogState createState() => _CustomRatingDialogState();

  /// Displays the [CustomRatingDialog].
  ///
  /// This method handles default behavior for good and bad reviews:
  ///
  /// - Good reviews (≥ 4 stars):
  ///   - Stops future prompts
  ///   - Triggers the in-app review request
  ///
  /// - Bad reviews (< 4 stars):
  ///   - Postpones the review prompt for 6 months
  ///   - Sends feedback via email
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CustomRatingDialog(
        onGoodReview: (rating, comment) async {
          Navigator.pop(context);
          await ReviewService().neverAskAgain();
          await ReviewService().forceRequestReview();
        },
        onBadReview: (rating, comment) async {
          Navigator.pop(context);
          await ReviewService().postponeReview(const Duration(days: 180));
          await ReviewService().sendEmailFeedback(rating, comment);
        },
      ),
    );
  }
}

/// State class for [CustomRatingDialog].
///
/// Manages:
/// - The selected star rating value.
/// - The optional user feedback comment.
/// - Dynamic UI updates based on the selected rating.
///
/// Behavior:
/// - Displays a 5-star rating bar with a default rating of 5.
/// - Shows a comment input field only when the rating is less than 4 stars.
/// - Triggers:
///     • [widget.onGoodReview] when rating ≥ 4
///     • [widget.onBadReview] when rating < 4
/// - Provides footer actions:
///     • "Never Ask Again" to permanently disable future prompts.
///     • "Ask Me Later" to postpone the review request.
///
/// Properly disposes the [_commentController] to prevent memory leaks.
class _CustomRatingDialogState extends State<CustomRatingDialog> {
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppStyle.primaryColor;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "How's your experience ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your feedback helps us improve\nand serve you better.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              unratedColor: Colors.grey[300],
              itemSize: 38,
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_rating >= 4) {
                    widget.onGoodReview(_rating, _commentController.text);
                  } else {
                    widget.onBadReview(_rating, _commentController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () async {
                await ReviewService().postponeReview(const Duration(days: 30));
                Navigator.pop(context);
              },
              child: Text(
                'Skip for Now',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[600],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            Visibility(
              visible: _rating < 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: TextField(
                  controller: _commentController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Any comments or feedback? (Optional)',
                    hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppStyle.primaryColor),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.black12 : Colors.grey[50],
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
