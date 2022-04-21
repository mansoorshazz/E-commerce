import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Bottom%20nav/bottom_nav.dart';
import 'package:e_commerce_app/views/Home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.black,
            )),
        title: Text(
          'Payment',
          style: TextStyle(
            color: themeColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: mediaQuery.height * 0.03,
                horizontal: mediaQuery.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Methods',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  RadioListTile(
                    value: 0,
                    activeColor: themeColor,
                    groupValue: 1,
                    onChanged: (value) {},
                    title: Text(
                      'Cash On Delivery',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  RadioListTile(
                    value: 1,
                    activeColor: themeColor,
                    groupValue: 1,
                    onChanged: (value) {},
                    title: Text(
                      'Online Payment',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 3,
              height: 1,
            ),
            buildPriceDescription(context),
            Divider(
              thickness: 3,
              height: 1,
            ),
            Image.asset(
              'assets/images/istockphoto-1066818018-612x612.jpg',
            ),
            buildCheckOutButton(context),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

// =========================================================================================
// This method is used to show the sign in button.

  ElevatedButton buildCheckOutButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(themeColor),
      ),
      onPressed: () {
        print('checkout');
        Get.to(BottomNavBar());

        // Get.to(BottomNavBar(), transition: Transition.downToUp);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.height * 0.017,
          horizontal: mediaQuery.height * 0.12,
        ),
        child: const Text(
          'Confirm',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

// ========================================================================================================
// This method is used to show the build price description.

  Padding buildPriceDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'Price( 3 items)',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                '15,0000',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                'Delivery charge',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                '150',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2,
            height: 35,
          ),
          Row(
            children: [
              Text(
                'Amount Payable',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Text(
                '150,150',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
