
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidgetShimmer extends StatelessWidget {
  const LoadingWidgetShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.grey.shade200,
      child: Row(
        children: [
          ...List.generate(
            3,
            (index) => Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.022),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Container(
                  width: mediaQuery.width * 0.22,
                  height: mediaQuery.width * 0.19,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}