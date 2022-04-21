import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/core/colors.dart';
import 'package:e_commerce_app/views/Account%20Details/account_details.dart';
import 'package:e_commerce_app/views/Home/home_screen.dart';
import 'package:e_commerce_app/views/Login/login_screen.dart';
import 'package:e_commerce_app/views/My%20Address/my_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({Key? key}) : super(key: key);

  final photoUrl = FirebaseAuth.instance.currentUser!.photoURL;
  final userName = FirebaseAuth.instance.currentUser!.displayName;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> accountsContents = [
      {
        'title': 'My Account',
        'icon': Icons.person,
        'function': () => Get.to(
              AccountDetailsScreen(),
              transition: Transition.fade,
            ),
      },
      {
        'title': 'My Address',
        'icon': Icons.list_alt,
        'function': () => Get.to(
              MyAdressScreen(),
              transition: Transition.fade,
            ),
      },
      {
        'title': 'Share App',
        'icon': Icons.share,
        'function': () {
          print('share');
        }
      },
      {
        'title': 'Help',
        'icon': Icons.contact_support,
        'function': () {
          print('help');
        }
      },
      {
        'title': 'About',
        'icon': Icons.description,
        'function': () {
          print('about');
        }
      },
      {
        'title': 'Logout',
        'icon': Icons.logout_sharp,
        'function': () {
          FirebaseAuth.instance
              .signOut()
              .then((value) => Get.offAll(LoginScreen()));
        }
      },
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: themeColor,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.white24,
                      highlightColor: Colors.grey.shade200,
                      child: CircleAvatar(
                        // backgroundColor: Colors.white,
                        radius: 70,
                      ),
                    );
                  }

                  final data = snapshot.data;

                  return CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: photoUrl == null
                        ? NetworkImage(data['imageUrl'])
                        : NetworkImage(photoUrl!),
                    // child: Center(
                    //   child: CircularProgressIndicator(backgroundColor: themeColor),
                    // ),
                  );
                }),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Shimmer.fromColors(
                    baseColor: Colors.red,
                    highlightColor: Colors.green,
                    child: const Text('Loading'),
                  );
                }

                final data = snapshot.data;

                if (snapshot.connectionState == ConnectionState.active) {
                  print('success');
                  return Text(
                    userName == '' ? data['userName'] : userName,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  );
                }

                return Text(
                  'dllkf',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.0055,
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: accountsContents.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 0,
                ),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: accountsContents[index]['function'],
                  child: Container(
                    height: 58,
                    color: Colors.transparent,
                    width: double.infinity,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Icon(accountsContents[index]['icon']),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          accountsContents[index]['title'],
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
