import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:curb_companion/features/review/presentation/vendor_rating_circular_chart.dart';
import 'package:curb_companion/features/review/presentation/vendor_review_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewVendorScreen extends ConsumerStatefulWidget {
  const ReviewVendorScreen({super.key});

  @override
  ReviewVendorScreenState createState() => ReviewVendorScreenState();
}

class ReviewVendorScreenState extends ConsumerState<ReviewVendorScreen> {
  @override
  Widget build(BuildContext context) {
    Vendor vendor = ModalRoute.of(context)!.settings.arguments as Vendor;
    final TextEditingController ratingController = TextEditingController();

    Widget buildRatingBar() {
      return RatingBar.builder(
        glowColor: Colors.grey,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.yellow.shade600,
        ),
        onRatingUpdate: (rating) {
          var userNotifier = ref.watch(userStateProvider.notifier);
          if (userNotifier.user == null) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).iconTheme.color,
                content: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      const TextSpan(
                          text:
                              "You must be logged in to leave a review. Please "),
                      TextSpan(
                        text: "login",
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();

                            Navigator.pushNamed(
                              context,
                              Routes.authScreen,
                            );
                          },
                      ),
                      const TextSpan(text: " or "),
                      TextSpan(
                        text: "register",
                        style: const TextStyle(
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                              context,
                              Routes.authScreen,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            );

            ratingController.text = "0";
            return;
          } else {
            ratingController.text = rating.toString();
            Navigator.pushNamed(
              context,
              Routes.createReviewScreen,
              arguments: [vendor, ratingController.text],
            );
          }
        },
      );
    }

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          elevation: 3,
          forceElevated: false,
          pinned: true,
          title: Text(vendor.title),
          titleSpacing: 0,
        ),
        SliverFillRemaining(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Material(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Text(
                          "Leave a review for ${vendor.title}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildRatingBar(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: Divider(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color!
                                .withOpacity(0.3)),
                      ),
                      VendorRatingCircularChart(
                        rating: vendor.rating,
                      ),
                      const SizedBox(height: 25),
                      if (vendor.reviews.isNotEmpty)
                        Column(
                          children: [
                            for (int i = 0; i < vendor.reviews.length; i++) ...[
                              VendorReviewCard(
                                review: vendor.reviews[i],
                                vendor: vendor,
                              ),
                              const SizedBox(height: 15),
                            ]
                          ],
                        ),
                      if (vendor.reviews.isEmpty)
                        const Text(
                          "No reviews yet.",
                          style: TextStyle(fontSize: 20),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
