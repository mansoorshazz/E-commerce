import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BuildStatusContent extends StatelessWidget {
  const BuildStatusContent({
    Key? key,
    required this.lottie,
    required this.text,
    required this.subText,
    this.bottom = 35,
    this.sizedBoxWidth = 20.0,
  }) : super(key: key);

  final String lottie;
  final String text;
  final String subText;
  final double bottom;
  final double sizedBoxWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: sizedBoxWidth,
          ),
          Lottie.network(
            lottie,
            repeat: false,
            animate: true,
            height: 40,
            width: 40,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                subText,
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
