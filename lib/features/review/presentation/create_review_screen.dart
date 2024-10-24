import 'package:curb_companion/shared/presentation/custom_text_form_field.dart';
import 'package:curb_companion/routes/routes.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/review/presentation/review_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateReviewScreen extends ConsumerStatefulWidget {
  const CreateReviewScreen({super.key});

  @override
  CreateReviewScreenState createState() => CreateReviewScreenState();
}

class CreateReviewScreenState extends ConsumerState<CreateReviewScreen> {
  final TextEditingController _ratingController = TextEditingController();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Extract the arguments
    final List<dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>?;

    // Extract the vendor and rating from the arguments
    final Vendor? passedDownVendor = arguments![0] as Vendor?;

    final String passedDownRating = arguments[1] as String;

    Widget buildRatingBar() {
      return RatingBar.builder(
        initialRating: double.parse(passedDownRating),
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
        onRatingUpdate: (newRating) {
          setState(() {
            _ratingController.text = newRating.toString();
          });
        },
      );
    }

    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          surfaceTintColor: Theme.of(context).colorScheme.background,
          title: const Text("Create a Review", style: TextStyle(fontSize: 25)),
        ),
        SliverFillRemaining(
          child: Material(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  buildRatingBar(),
                  const SizedBox(height: 10),
                  Text(
                      _ratingController.text != ""
                          ? _ratingController.text.replaceAll(".0", "")
                          : passedDownRating.replaceAll(".0", ""),
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 60),
                  CustomTextField(
                    hintText: "Title",
                    onChanged: (value) {
                      setState(() {
                        _titleController.text = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Description",
                    maxLines: 4,
                    onChanged: (value) {
                      setState(() {
                        _descriptionController.text = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 42,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        double rating = _ratingController.text != ""
                            ? double.parse(_ratingController.text)
                            : double.parse(passedDownRating);
                        await ref
                            .watch(reviewStateProvider.notifier)
                            .createVendorReview(
                              passedDownVendor!.id,
                              _titleController.text,
                              _descriptionController.text,
                              rating,
                            );

                        if (!mounted) return;
                        Navigator.pushNamed(
                          context,
                          Routes.reviewVendorScreen,
                          arguments: passedDownVendor,
                        );
                      },
                      child: const Text("Submit Review"),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
