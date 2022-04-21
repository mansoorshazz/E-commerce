import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class BuildTextField extends StatelessWidget {
  BuildTextField({
    Key? key,
    required this.hintText,
    required this.initialValue,
  }) : super(key: key);

  final String hintText;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: controller,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      initialValue: initialValue,
      style: TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
      onEditingComplete: () {},
      validator: (value) {
        if (value!.isEmpty) {
          return '*required';
        }
        return null;
      },
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
                onPressed: () {},
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
