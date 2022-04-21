import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/views/Account%20Details/account_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Account {
  static updateUserName(
    BuildContext context,
    TextEditingController controller,
  ) {
    final provider = FirebaseAuth.instance.currentUser!.providerData;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update your userName'),
          content: TextFormField(
            initialValue: controller.text,
            textInputAction: TextInputAction.go,
            onChanged: (value) {
              if (provider[0].providerId == 'google.com') {
                FirebaseAuth.instance.currentUser!.updateDisplayName(value);
              } else {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({'userName': value});
              }
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(hintText: "Update username!"),
          ),
          actions: <Widget>[
            OutlinedButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
    // Get.bottomSheet(
    //   Container(
    //     color: Colors.white,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: TextFormField(
    //             initialValue: controller.text,
    //             onChanged: (value) {
    //               FirebaseFirestore.instance
    //                   .collection('Users')
    //                   .doc(FirebaseAuth.instance.currentUser!.uid)
    //                   .update({'userName': value});
    //             },
    //             decoration: InputDecoration(
    //               hintText: "Update userName",
    //               enabledBorder: OutlineInputBorder(
    //                 borderSide: BorderSide(
    //                   color: Colors.black12,
    //                   width: 1.5,
    //                 ),
    //               ),
    //               focusedBorder: OutlineInputBorder(
    //                 borderSide: BorderSide(
    //                   color: Colors.black45,
    //                   width: 1.5,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             FocusScope.of(context).unfocus();
    //             Get.back();
    //           },
    //           child: Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    //             child: Text('Save'),
    //           ),
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  static uploadProfileImage(XFile xFile, File file) async {
    try {
      var snapshot = FirebaseStorage.instance
          .ref(FirebaseAuth.instance.currentUser!.uid)
          .child('Profile-Images/${xFile.name}');

      final metadata = SettableMetadata(
        contentType: 'image',
        customMetadata: {
          'picked-file-path': file.path,
          'name': xFile.name,
        },
      );

      await snapshot.putFile(file, metadata);

      String imageUrl = await snapshot.getDownloadURL();

      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print(e);
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Warning',
          message: 'Something went wrong please try again later!',
        ),
      );
    }
  }
}
