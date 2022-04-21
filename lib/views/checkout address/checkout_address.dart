import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/controller/radio_button.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/My%20Address/Add%20address/add_address.dart';
import 'package:e_commerce_app/views/My%20Address/Edit%20address/edit_address.dart';
import 'package:e_commerce_app/views/Payment/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CheckOutAddress extends StatelessWidget {
  CheckOutAddress({Key? key}) : super(key: key);

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    Get.put(RadioButtonController());

    final mediaQuery = MediaQuery.of(context).size;
    final addressStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Address',
          style: TextStyle(
            color: themeColor,
          ),
        ),
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('Addresses')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                buildAddAddressbutton(mediaQuery),
                buildAddress(addressStyle, mediaQuery, snapshot),
                buildConfirmButton(context),
                SizedBox(
                  height: 10,
                )
              ],
            );
          }),
    );
  }

// ================================================================================
  ElevatedButton buildConfirmButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(HexColor('#EF0030').withOpacity(0.8)),
      ),
      onPressed: () {
        Get.to(
          PaymentScreen(),
          transition: Transition.leftToRight,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: mediaQuery.height * 0.015,
            horizontal: mediaQuery.width * 0.2),
        child: Text(
          'Deliver  Here',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

// ====================================================================================================
  GestureDetector buildAddAddressbutton(Size mediaQuery) {
    return GestureDetector(
      onTap: () {
        Get.to(
          AddAddressScreen(),
          transition: Transition.downToUp,
        );
      },
      child: ClayContainer(
        emboss: true,
        child: Row(
          children: [
            SizedBox(
              width: mediaQuery.width * 0.05,
            ),
            const Icon(CupertinoIcons.add_circled, size: 25),
            SizedBox(
              width: mediaQuery.width * 0.04,
            ),
            const Text(
              'Add a new address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        color: Colors.white,
        height: 70,
      ),
    );
  }

  //========================================================================
  Expanded buildAddress(
    TextStyle addressStyle,
    Size mediaQuery,
    AsyncSnapshot<QuerySnapshot> snapshot,
  ) {
    return Expanded(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final doc = snapshot.data!.docs[index];

          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: GetBuilder<RadioButtonController>(builder: (controller) {
              return InkWell(
                onTap: (){
                  controller.changeRadioButton(index);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio<int>(
                          value: index,
                          groupValue: controller.selectedIndex,
                          onChanged: (value) {
                            controller.changeRadioButton(value!);
                          },
                          activeColor: themeColor,
                        ),
                        Text(
                          doc['userName'],
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              EditAddressScreen(
                                docId: doc.id,
                                userName: doc['userName'],
                                phoneNumber: doc['phoneNumber'],
                                pincode: doc['pincode'],
                                state: doc['state'],
                                city: doc['city'],
                              ),
                              transition: Transition.leftToRight,
                            );
                          },
                          child: Text('Edit'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: mediaQuery.width * 0.13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['city'],
                            style: addressStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            doc['state'],
                            style: addressStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            doc['pincode'],
                            style: addressStyle,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            doc['phoneNumber'],
                            style: addressStyle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            }),
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 5,
        ),
        itemCount: snapshot.data!.docs.length,
      ),
    );
  }
}
