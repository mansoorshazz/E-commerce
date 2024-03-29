import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Orders/HelpChat/help_chat.dart';
import 'package:e_commerce_app/widgets/shimmer_lodaing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'widgets/status_bar_content.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    Key? key,
    required this.productId,
    required this.quantity,
    required this.address,
    required this.totalPrice,
    required this.documentId,
  }) : super(key: key);

  final String productId;
  final int quantity;
  final Map address;
  final int totalPrice;
  final String documentId;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    const addressStyle = TextStyle(
      fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    );

    print(quantity);

    var formatter = NumberFormat('#,##,000');

    String productPrice = formatter.format(totalPrice / quantity);

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
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Orders')
              .doc(documentId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingShimmer();
            }

            var orderMap = snapshot.data;

            // bool isOrdered = orderMap['ordered'];

            // bool isShipped = orderMap['shipped'];

            // bool isDelivered = orderMap['delivered'];

            // final orderdate = DateTime.fromMillisecondsSinceEpoch(
            //   orderMap['orderDetails']['date'],
            // );

            // final formatedOrderDate = DateFormat.yMMMd().format(orderdate);

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    bottom: 12,
                  ),
                  child: Text(
                    'Order ID - ${documentId}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black26,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.2),
                  thickness: 4,
                  height: 30,
                ),
                buildProductDetails(
                  orderMap,
                  productPrice,
                  context,
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.2),
                  thickness: 4,
                  height: 20,
                ),
                const SizedBox(
                  height: 25,
                ),
                buildDeliveryStatusBar(
                  context,
                  orderMap: orderMap,
                ),
                Divider(
                  color: Colors.grey.withOpacity(0.2),
                  thickness: 4,
                  height: 0,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 5),
                  child: Text(
                    'Shipping Details',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                    ),
                  ),
                ),
                const Divider(),
                buildAdress(
                  addressStyle,
                  snapshot,
                ),
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
                buildPriceDescription(context, snapshot),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton.icon(
                    onPressed: () => Get.to(HelpChat(
                      docId: documentId,
                    )),
                    icon: Icon(Icons.message),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text('Help'),
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

// =============================================================================================
// This method show the full productDetails

  Padding buildProductDetails(doc, String productPrice, BuildContext context) {
    return Padding(
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
                doc['productName'],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                doc['sizeOrVarient'],
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    '₹$productPrice',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Icons.close,
                    size: 13,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ],
          ),
          const Spacer(),
          Image.network(
            doc['imageUrl'],
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.35,
          ),
        ],
      ),
    );
  }

// ========================================================================
// This method is used to show the shipping address.

  Padding buildAdress(
    TextStyle addressStyle,
    AsyncSnapshot snapshot,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address['name'],
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            address['city'],
            style: addressStyle,
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            "${address['state']} -  ${address['pincode']}",
            style: addressStyle,
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            address['phoneNumber'],
            style: addressStyle,
          ),
        ],
      ),
    );
  }

// =========================================================================================
// This method is used to show the delivery status bar.

  Column buildDeliveryStatusBar(BuildContext context,
      {required dynamic orderMap}) {
    final mediaQuery = MediaQuery.of(context).size;

    //   print(orderMap.runtimeType);

    //  final data = json.encode(orderMap['shippingAddress']);

    //  print(data.runtimeType);

    // bool isOrdered = orderMap['ordered'];

    bool isShipped = orderMap['shipped'];

    bool isDelivered = orderMap['delivered'];

    final orderdate = DateTime.fromMillisecondsSinceEpoch(
      orderMap['orderedDate'],
    );

    final shippedDate = DateTime.fromMillisecondsSinceEpoch(
      orderMap['shippedDate'],
    );

    final deliveredDate = DateTime.fromMillisecondsSinceEpoch(
      orderMap['deliveredDate'],
    );

    final formatedOrderDate = DateFormat.yMMMd().format(orderdate);
    final formatedshippedDate = DateFormat.yMMMd().format(shippedDate);
    final formatedDeliveredDate = DateFormat.yMMMd().format(deliveredDate);

    return Column(
      children: [
        TimeLIneWidget(
          mediaQuery: mediaQuery,
          isFirst: true,
          indicatiorColor: themeColor,
          afterlineColor: themeColor.withOpacity(0.6),
          beforlineColor: Colors.black12,
          buildStatusContent: BuildStatusContent(
            lottie:
                'https://assets10.lottiefiles.com/packages/lf20_waspcuqo.json',
            text: 'Ordered',
            subText: 'Ordered on $formatedOrderDate',
            bottom: 8,
            sizedBoxWidth: 5,
          ),
        ),
        TimeLIneWidget(
          mediaQuery: mediaQuery,
          indicatiorColor: isShipped ? themeColor : Colors.white,
          afterlineColor:
              isShipped ? themeColor.withOpacity(0.6) : Colors.black12,
          beforlineColor:
              isShipped ? themeColor.withOpacity(0.6) : Colors.black12,
          buildStatusContent: BuildStatusContent(
            lottie:
                'https://assets5.lottiefiles.com/packages/lf20_1n2cvwnt.json',
            text: 'Shipped',
            subText: shippedDate.millisecondsSinceEpoch == 0
                ? 'Your item has not been shipped'
                : 'Shipped on $formatedshippedDate',
            bottom: 8,
            sizedBoxWidth: 5,
          ),
        ),
        TimeLIneWidget(
          mediaQuery: mediaQuery,
          isLast: true,
          indicatiorColor: isDelivered ? themeColor : Colors.white,
          afterlineColor:
              isDelivered ? themeColor.withOpacity(0.6) : Colors.black12,
          beforlineColor:
              isDelivered ? themeColor.withOpacity(0.6) : Colors.black12,
          buildStatusContent: BuildStatusContent(
            lottie:
                'https://assets8.lottiefiles.com/private_files/lf30_cyp2olco.json',
            text: 'Delivered',
            subText: deliveredDate.millisecondsSinceEpoch == 0
                ? 'Your item has been not delivered'
                : 'Delivered on $formatedDeliveredDate',
            bottom: 8,
            sizedBoxWidth: 5,
          ),
        ),
      ],
    );
  }

// ========================================================================================================
// This method is used to show the build price description.

  buildPriceDescription(
    BuildContext context,
    AsyncSnapshot snapshot,
  ) {
    final doc = snapshot.data;

    var formatter = NumberFormat('#,##,000');

    String convertPrice = formatter.format(totalPrice / quantity);
    String convertPriceTotalSum = formatter.format(totalPrice);

    return Padding(
      padding: EdgeInsets.only(top: 10, right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                doc['paymentMethod'],
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const Text(
                'Product Price',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                convertPrice,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const Text(
                'Product Quantity',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 2,
            height: 35,
          ),
          Row(
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                '₹$convertPriceTotalSum',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeLIneWidget extends StatelessWidget {
  const TimeLIneWidget({
    Key? key,
    required this.mediaQuery,
    required this.indicatiorColor,
    required this.afterlineColor,
    required this.beforlineColor,
    required this.buildStatusContent,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  final Size mediaQuery;
  final Color indicatiorColor;
  final Color afterlineColor;
  final Color beforlineColor;
  final bool isFirst;
  final bool isLast;
  final BuildStatusContent buildStatusContent;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      alignment: TimelineAlign.manual,
      lineXY: 0.08,
      endChild: Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery.width * 0.07,
          left: mediaQuery.width * 0.02,
        ),
        child: buildStatusContent,
      ),
      afterLineStyle: LineStyle(
        color: afterlineColor,
        thickness: 2.5,
      ),
      beforeLineStyle: LineStyle(
        color: beforlineColor,
        thickness: 2.5,
      ),
      indicatorStyle: IndicatorStyle(
        color: indicatiorColor,
        indicatorXY: 0.3,
        indicator: Container(
          decoration: BoxDecoration(
            color: indicatiorColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black12,
              width: 1.5,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 0.4,
        ),
      ),
    );
  }
}
