import 'package:e_commerce_app/model/Firebase/address.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PincodeTextfieldWidget extends StatelessWidget {
  const PincodeTextfieldWidget({
    Key? key,
    this.width = double.infinity,
    required this.initialValue,
    required this.docId,
  }) : super(key: key);

  final double width;
  final String initialValue;
  final String docId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        // controller: controller,
        initialValue: initialValue,
        cursorColor: Colors.black,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return '*required';
          } else if (value.length != 6) {
            return '*enter 6 numbers';
          }
          return null;
        },
        onChanged: (value) {
          Address.updateAdress(
            field: 'pincode',
            updateValue: value,
            docId: docId,
          );
        },
        decoration: const InputDecoration(
          // hintText: hintText,

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
