import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Account/account.dart';
import 'package:e_commerce_app/views/Home/home_screen.dart';
import 'package:e_commerce_app/views/Orders/orders.dart';
import 'package:e_commerce_app/views/Wishlist/wishlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: SafeArea(
        child: Scaffold(
            bottomNavigationBar: PersistentTabView(
          context,
          navBarStyle: NavBarStyle.style3,
          decoration: const NavBarDecoration(colorBehindNavBar: Colors.red),
          screens: [
            HomeScreen(),
            WishListScreen(),
            OrderScreen(),
            AccountScreen(),
          ],
          items: [
            PersistentBottomNavBarItem(
              activeColorPrimary: themeColor,
              inactiveColorPrimary: Colors.black,
              icon: Icon(
                CupertinoIcons.house_fill,
              ),
              inactiveIcon: Icon(CupertinoIcons.home),
              title: 'Home',
            ),
            PersistentBottomNavBarItem(
              activeColorPrimary: themeColor,
              inactiveColorPrimary: Colors.black,
              inactiveIcon: Icon(
                Icons.favorite_border_outlined,
              ),
              icon: Icon(Icons.favorite),
              title: 'Wishlist',
            ),
            PersistentBottomNavBarItem(
              activeColorPrimary: themeColor,
              inactiveColorPrimary: Colors.black,
              inactiveIcon: Icon(
                Icons.shopping_bag_outlined,
                size: 27,
              ),
              icon: Icon(
                CupertinoIcons.bag_fill,
              ),
              title: 'Orders',
            ),
            PersistentBottomNavBarItem(
                activeColorPrimary: themeColor,
                inactiveColorPrimary: Colors.black,
                inactiveIcon: Icon(Icons.person_outline_outlined),
                icon: const Icon(
                  Icons.person,
                ),
                title: 'Account')
          ],
        )),
      ),
    );
  }
}
