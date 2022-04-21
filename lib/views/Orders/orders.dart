import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Orders/Details/order_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Orders',
          style: TextStyle(
            color: themeColor,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        separatorBuilder: (context, index) => Divider(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => Get.to(
              OrderDetailsScreen(),
              transition: Transition.leftToRight,
            ),
            leading: Image.network(
              'https://m.media-amazon.com/images/I/71E5zB1qbIL._SX522_.jpg',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
            title: Text(
              'Delivered on Mar 20',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'I Phone 11',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              size: 15,
            ),
          );
        },
      ),
    );
  }
}
