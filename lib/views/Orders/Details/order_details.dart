
import 'package:e_commerce_app/core/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'widgets/status_bar_content.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final addressStyle = TextStyle(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Order Details',
          style: TextStyle(
            color: themeColor,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              bottom: 12,
            ),
            child: Text(
              'Order ID - wkljdljjshfhsdhf',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black26,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // SizedBox(height: 10,),
          Divider(
            color: Colors.grey.withOpacity(0.2),
            thickness: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'I Phone 11',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '6/128',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '50,000',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Image.network(
                  "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-12-blue-select-2020?wid=940&hei=1112&fmt=png-alpha&.v=1604343704000",
                  width: 100,
                  height: 150,
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.2),
            thickness: 4,
            height: 0,
          ),
          SizedBox(
            height: 25,
          ),
          buildDeliveryStatusBar(context),

          Divider(
            color: Colors.grey.withOpacity(0.2),
            thickness: 4,
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
            child: Text(
              'Shipping Details',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black38,
              ),
            ),
          ),
          Divider(),
          buildAdress(addressStyle),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey.withOpacity(0.2),
            thickness: 4,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
            child: Text(
              'Price Details',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black38,
              ),
            ),
          ),
          Divider(),
          buildPriceDescription(context),
          SizedBox(height: 10,)
        ],
      ),
    );
  }

// ========================================================================
// This method is used to show the shipping address.

  Padding buildAdress(TextStyle addressStyle) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mansoor',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Tirur',
            style: addressStyle,
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            'Kerala  -  676551',
            style: addressStyle,
          ),
          SizedBox(
            height: 7,
          ),
          Text(
            '7558967627',
            style: addressStyle,
          ),
        ],
      ),
    );
  }

// =========================================================================================
// This method is used to show the delivery status bar.

  Column buildDeliveryStatusBar(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Column(
      children: [
        TimelineTile(
          isFirst: true,
          alignment: TimelineAlign.manual,
          lineXY: 0.08,
          endChild: Padding(
            padding: EdgeInsets.only(
              bottom: mediaQuery.width * 0.07,
              left: mediaQuery.width * 0.04,
            ),
            child: BuildStatusContent(
              image: 'assets/images/Checklist-Logo.png',
              text: 'Ordered',
              subText: 'Ordered on Mar 20 2022',
              bottom: 8,
              sizedBoxWidth: 5,
            ),
          ),
          afterLineStyle:
              LineStyle(color: themeColor.withOpacity(0.6), thickness: 3),
          indicatorStyle: IndicatorStyle(
            color: themeColor,
            indicatorXY: 0.3,
            padding: EdgeInsets.only(
              top: 5,
            ),
          ),
        ),
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.08,
          endChild: BuildStatusContent(
            image: 'assets/images/f8a162a8cf5ae11b9b2f92d624d9c527.png',
            text: 'Shipped',
            subText: 'Shipped on Mar 20 2022',
          ),
          beforeLineStyle: LineStyle(color: Colors.black12, thickness: 3),
          afterLineStyle: LineStyle(color: Colors.black12, thickness: 3),
          indicatorStyle: IndicatorStyle(
            color: Colors.black12,
            height: 20,
            width: 20,
            indicator: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black12,
                    width: 2,
                  )),
            ),
            indicatorXY: 0.3,
            padding: EdgeInsets.only(
              top: 1,
              bottom: 1,
            ),
          ),
        ),
        TimelineTile(
          isLast: true,
          endChild: BuildStatusContent(
            image: 'assets/images/pickup-your-delivery-2839465-2371175.webp',
            text: 'Delivered',
            subText: 'Delivered on Mar 20 2022',
          ),
          alignment: TimelineAlign.manual,
          lineXY: 0.08,
          beforeLineStyle: LineStyle(color: Colors.black12, thickness: 3),
          indicatorStyle: IndicatorStyle(
            color: Colors.black12,
            height: 20,
            width: 20,
            indicator: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black12,
                    width: 2,
                  )),
            ),
            indicatorXY: 0.3,
            padding: EdgeInsets.only(top: 1),
          ),
        ),
      ],
    );
  }

// ========================================================================================================
// This method is used to show the build price description.

  buildPriceDescription(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                'Total Amount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
