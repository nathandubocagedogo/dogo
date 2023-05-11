import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NearbyPlacesShimmerWidget extends StatelessWidget {
  final int index;
  final double screenWidth;

  const NearbyPlacesShimmerWidget({
    super.key,
    required this.index,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: index == 0 ? screenWidth * 0.05 : 0,
        right: index == 1 ? screenWidth * 0.05 : 0,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02), // Ajoute une marge horizontale
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: 300,
          height: 200,
        ),
      ),
    );
  }
}
