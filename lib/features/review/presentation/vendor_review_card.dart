import 'package:curb_companion/features/review/domain/review.dart';
import 'package:curb_companion/features/vendor/domain/vendor.dart';
import 'package:curb_companion/features/user/presentation/user_state_notifier.dart';
import 'package:curb_companion/features/review/presentation/review_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorReviewCard extends ConsumerStatefulWidget {
  final Review? review;
  final Vendor? vendor;
  const VendorReviewCard({super.key, this.review, this.vendor});

  @override
  VendorReviewCardState createState() => VendorReviewCardState();
}

class VendorReviewCardState extends ConsumerState<VendorReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // yellow stars for full ratings
                    for (int i = 0; i < widget.review!.rating.floor(); i++)
                      Icon(
                        Icons.star,
                        color: Colors.yellow.shade600,
                        size: 20,
                      ),
                    // half star if applicable
                    if (widget.review!.rating % 1 != 0)
                      Icon(
                        Icons.star_half,
                        color: Colors.yellow.shade600,
                        size: 20,
                      ),
                    // grey stars for remaining empty slots
                    for (int i = 0; i < 5 - widget.review!.rating.ceil(); i++)
                      const Icon(
                        Icons.star,
                        color: Colors.grey,
                        size: 20,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.review?.title ?? 'Review Title',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(widget.review?.description ?? 'Review Description'),
              const SizedBox(height: 16.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "${widget.review?.createdAt.month}/${widget.review?.createdAt.day}/${widget.review?.createdAt.year}",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 15,
          child: PopupMenuButton<String>(
            color: Theme.of(context).colorScheme.background,
            elevation: 3,
            onSelected: (value) async {
              if (value == 'report_review') {
                widget.review!.isReported = true;
              }
              if (value == 'delete_review') {
                await ref
                    .watch(reviewStateProvider.notifier)
                    .deleteVendorReview(widget.vendor!.id);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'report_review',
                child: Text(
                  'Report Review',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color),
                ),
              ),

              // if the review is the current user's review, then have the option to delete
              if (ref.watch(userStateProvider.notifier).user != null &&
                  widget.review!.userId ==
                      ref.watch(userStateProvider.notifier).user!.id)
                PopupMenuItem<String>(
                  value: 'delete_review',
                  child: Text(
                    'Delete Review',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                ),
            ],
            child: Icon(
              Icons.more_horiz,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(0.85),
              size: 25,
            ),
          ),
        )
      ],
    );
  }
}
