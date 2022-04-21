import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AddressTextfield extends StatelessWidget {
  AddressTextfield({
    Key? key,
    this.width = double.infinity,
    this.keyboardType = TextInputType.streetAddress,
    this.maxLength = 20,
    required this.controller,
  }) : super(key: key);

  final double width;
  TextInputType keyboardType;
  TextEditingController controller;
  int maxLength;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
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
          }
          return null;
        },
        decoration: const InputDecoration(
          counterText: '',
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

          // hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.all(10),
          // focusColor: Colors.amber,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black26,
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
