import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NearbyPlacesShimmerWidget extends StatelessWidget {
  final double screenWidth;

  const NearbyPlacesShimmerWidget({
    super.key,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(seconds: 3),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          width: double.infinity,
          height: 200,
        ),
      ),
    );
  }
}
