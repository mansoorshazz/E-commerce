import 'package:e_commerce_app/views/My%20Address/Add%20address/widgets/textfield.dart';
import 'package:e_commerce_app/views/My%20Address/Add%20address/widgets/textfield_text.dart';
import 'package:e_commerce_app/views/My%20Address/Edit%20address/widgets/edit_textfield_text.dart';
import 'package:e_commerce_app/views/My%20Address/Edit%20address/widgets/phonetextfield.dart';
import 'package:e_commerce_app/views/My%20Address/Edit%20address/widgets/pincode_textfield.dart';
import 'package:e_commerce_app/views/My%20Address/Edit%20address/widgets/place_textfield.dart';
import 'package:e_commerce_app/views/My%20Address/Edit%20address/widgets/state_textfield.dart';
import 'package:e_commerce_app/views/My%20Address/Edit%20address/widgets/usernametextfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class EditAddressScreen extends StatelessWidget {
  EditAddressScreen({
    required this.docId,
    Key? key,
    required this.userName,
    required this.phoneNumber,
    required this.city,
    required this.pincode,
    required this.state,
  }) : super(key: key);

  final String docId;
  final String userName;
  final String phoneNumber;
  final String city;
  final String pincode;
  final String state;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    final textHeight = SizedBox(
      height: mediaQuery.height * 0.007,
    );

    final textfieldHeight = SizedBox(
      height: mediaQuery.height * 0.045,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textfieldHeight,
                EdtiAddressTextfieldText(
                  text: 'Full Name',
                ),
                textHeight,
                UsernameTextfield(
                  initialValue: userName,
                  docId: docId,
                ),
                textfieldHeight,
                EdtiAddressTextfieldText(
                  text: 'Phone Number',
                ),
                textHeight,
                PhoneTextfield(
                  initialValue: phoneNumber,
                  docId: docId,
                ),
                textfieldHeight,
                EdtiAddressTextfieldText(
                  text: 'Place',
                ),
                textHeight,
                PlaceTextfield(
                  initialValue: city,
                  docId: docId,
                ),
                textfieldHeight,
                EdtiAddressTextfieldText(
                  text: 'Pincode',
                ),
                textHeight,
                PincodeTextfieldWidget(
                  initialValue: pincode,
                  width: mediaQuery.width * 0.40,
                  docId: docId,
                ),
                textfieldHeight,
                EdtiAddressTextfieldText(
                  text: 'State',
                ),
                textHeight,
                StateTextfield(
                  initialValue: state,
                  width: mediaQuery.width * 0.40,
                  docId: docId,
                ),
                SizedBox(
                  height: mediaQuery.height * 0.068,
                ),
                buildSaveButton(
                  mediaQuery,
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// ========================================================================================
// This method is used to show the save button.

  Center buildSaveButton(
    Size mediaQuery,
    BuildContext context,
  ) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            HexColor('#EF0030').withOpacity(0.8),
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Get.back();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Update address successfully'),
              ),
            );
          }
          // Get.to(BottomNavBar(), transition: Transition.downToUp);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: mediaQuery.height * 0.018,
              horizontal: mediaQuery.width * 0.3),
          child: Text(
            'SAVE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
