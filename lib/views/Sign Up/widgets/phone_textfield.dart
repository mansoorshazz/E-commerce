import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PhoneNumberTextfield extends StatelessWidget {
  const PhoneNumberTextfield({
    Key? key,
    this.height = 50,
    this.keyboardType = TextInputType.name,
    required this.controller,
    required this.icon,
    this.visible = false,
  }) : super(key: key);

  final TextInputType keyboardType;
  final double height;
  final TextEditingController controller;
  final IconData icon;
  final bool visible;

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
          if (value!.isEmpty) {
            return '*required';
          } else if (value.length != 10) {
            return 'please enter 10 numbers';
          }
          return null;
        },
        maxLength: 10,
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
          // suffixIconColor: Colors.black,
          // suffixStyle: TextStyle(
          //   color: Colors.black,
          // ),
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
          // hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.all(10),
          // focusColor: Colors.amber,
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