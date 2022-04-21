import 'package:e_commerce_app/model/Firebase/account.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AccountUserNameTextfield extends StatelessWidget {
  AccountUserNameTextfield({
    Key? key,
    required this.hintText,
    required this.initialValue,
    required this.controller,
  }) : super(key: key);

  final String hintText;
  final String initialValue;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    controller.text = initialValue;

    return TextFormField(
      cursorColor: Colors.black,
      initialValue: initialValue,
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        suffixIconColor: Colors.black,
        suffixStyle: TextStyle(
          color: Colors.black,
        ),

        suffixIcon: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VerticalDivider(
                color: HexColor('#583C3C').withOpacity(0.17),
                thickness: 1,
              ),
              IconButton(
                onPressed: () {
                  Account.updateUserName(context, controller);
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        // hintStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.only(left: 10),
        // focusColor: Colors.amber,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
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
    );
  }
}
