import 'package:e_commerce_app/model/Firebase/address.dart';
import 'package:e_commerce_app/views/My%20Address/Add%20address/widgets/textfield.dart';
import 'package:e_commerce_app/views/My%20Address/Add%20address/widgets/textfield_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AddAddressScreen extends StatelessWidget {
  AddAddressScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();

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
                AddressTextfieldText(
                  text: 'Full Name',
                ),
                textHeight,
                AddressTextfield(
                  controller: nameController,
                ),
                textfieldHeight,
                AddressTextfieldText(
                  text: 'Phone Number',
                ),
                textHeight,
                AddressTextfield(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),
                textfieldHeight,
                AddressTextfieldText(
                  text: 'Place',
                ),
                textHeight,
                AddressTextfield(
                  controller: placeController,
                ),
                textfieldHeight,
                AddressTextfieldText(
                  text: 'Pincode',
                ),
                textHeight,
                AddressTextfield(
                  width: mediaQuery.width * 0.40,
                  controller: pincodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                textfieldHeight,
                AddressTextfieldText(
                  text: 'State',
                ),
                textHeight,
                AddressTextfield(
                  width: mediaQuery.width * 0.40,
                  controller: stateController,
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

  Center buildSaveButton(Size mediaQuery, BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            HexColor('#EF0030').withOpacity(0.8),
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Address address = Address(
              userName: nameController.text,
              city: placeController.text,
              state: stateController.text,
              pincode: pincodeController.text,
              phoneNumber: phoneNumberController.text,
            );

            Address.addAddress(address, context);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: mediaQuery.height * 0.018,
              horizontal: mediaQuery.width * 0.3,
              ),
          child: const Text(
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
