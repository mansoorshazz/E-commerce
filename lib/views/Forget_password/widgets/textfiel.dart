import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ForgetEmailField extends StatelessWidget {
  ForgetEmailField({
    Key? key,
    required this.controller,
    required this.formkey,
  }) : super(key: key);

  final TextEditingController controller;
  final GlobalKey formkey;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(15),
      child: Form(
        key: formkey,
        child: TextFormField(
          controller: controller,
          cursorColor: Colors.black,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
          validator: (value) => value != null && !EmailValidator.validate(value)
              ? 'Enter a valid email'
              : null,
          decoration: InputDecoration(
            hintText: 'Email',
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
                    Icons.email_outlined,
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
      ),
    );
  }
}
