import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/material.dart';

class VendorRatingCircularChart extends StatelessWidget {
  final double rating;
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      GlobalKey<AnimatedCircularChartState>();

  VendorRatingCircularChart({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final double ratingPercentage = rating / 5.0 * 100.0;
    final int fullStars = rating.floor();
    final bool hasHalfStar = rating - fullStars >= 0.5;

    final data = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            ratingPercentage,
            Colors.yellow.shade600,
            rankKey: 'filled',
          ),
          CircularSegmentEntry(
            100 - ratingPercentage,
            Colors.grey.withOpacity(0.4),
            rankKey: 'empty',
          ),
        ],
        rankKey: 'Rating',
      ),
    ];

    return Stack(
      children: [
        AnimatedCircularChart(
          key: _chartKey,
          size: const Size(175.0, 175.0),
          initialChartData: data,
          chartType: CircularChartType.Radial,
          holeLabel: rating.toStringAsFixed(1),
          edgeStyle: SegmentEdgeStyle.round,
          labelStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          duration: const Duration(milliseconds: 1000),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              if (index < fullStars) {
                return Icon(
                  Icons.star,
                  color: Colors.yellow.shade600,
                  size: 18,
                );
              } else if (index == fullStars && hasHalfStar) {
                return Icon(
                  Icons.star_half,
                  color: Colors.yellow.shade600,
                  size: 18,
                );
              } else {
                return const Icon(
                  Icons.star,
                  color: Colors.grey,
                  size: 18,
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}
