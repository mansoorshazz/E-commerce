import 'package:e_commerce_app/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class EmailTextfield extends StatelessWidget {
  EmailTextfield({
    Key? key,
    this.height = 50,
    this.keyboardType = TextInputType.name,
    required this.controller,
    required this.icon,
  }) : super(key: key);

  final TextInputType keyboardType;
  final double height;
  final TextEditingController controller;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context).size;

    return SizedBox(
      // height: 50,
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: keyboardType,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        validator: (value) {
          String p =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

          RegExp regExp = new RegExp(p);
          if (value!.isEmpty) {
            return '*required';
          } else if (!regExp.hasMatch(value)) {
            return '*please enter valid email';
          }
          return null;
        },
        decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          prefixIcon: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  color: Colors.black,
                ),
                VerticalDivider(
                  color: HexColor('#583C3C').withOpacity(0.17),
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                )
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor('#583C3C').withOpacity(0.17),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
