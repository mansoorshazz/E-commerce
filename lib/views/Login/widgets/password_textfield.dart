import 'package:e_commerce_app/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class PasswordTextfield extends StatelessWidget {
  PasswordTextfield({
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
    Get.put(LoginController());
    return SizedBox(
      child: GetX<LoginController>(
        builder: (logincontroller) => TextFormField(
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
            }
            if (value.length < 8) {
              return '*password atleast 8 characters';
            }
            return null;
          },
          obscureText: logincontroller.visible.value,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                logincontroller.visible.value = !logincontroller.visible.value;
              },
              icon: Icon(
                logincontroller.visible.value
                    ? Icons.remove_red_eye
                    : Icons.visibility_off,
              ),
            ),

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
            suffixIconColor: Colors.black,
            suffixStyle: TextStyle(
              color: Colors.black,
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
