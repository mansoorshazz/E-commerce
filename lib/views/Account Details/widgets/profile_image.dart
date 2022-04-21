import 'package:e_commerce_app/controller/account_controller.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildProfileImage extends StatelessWidget {
  const BuildProfileImage({
    Key? key,
    required this.mediaQuery,
    required this.imageUrl,
  }) : super(key: key);

  final Size mediaQuery;

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    Get.put(AccountController());
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: mediaQuery.height * 0.105,
            backgroundImage: NetworkImage(
              imageUrl,
            ),
          ),
          Positioned(
            left: mediaQuery.width * 0.32,
            bottom: mediaQuery.height * 0.01,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: mediaQuery.width * 0.063,
              child: GetBuilder<AccountController>(builder: (controller) {
                return CircleAvatar(
                  backgroundColor: themeColor,
                  child: IconButton(
                    splashRadius: mediaQuery.width * 0.073,
                    onPressed: () {
                      controller.imageUpload();
                    },
                    icon: Icon(
                      CupertinoIcons.camera,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
