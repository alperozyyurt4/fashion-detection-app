// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  const AuthFormField({
    super.key,
    required this.formFocusColor,
    required this.formHintText,
    this.labelTextColor = Colors.black,
    this.formBorderRadius = const BorderRadius.all(Radius.circular(10)),
    required this.controller,
    required this.validator,
  });

  final Color formFocusColor;
  final BorderRadius formBorderRadius;
  final String formHintText;
  final Color labelTextColor;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: formHintText == 'Password',
      validator: validator,
      controller: controller,
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        focusColor: formFocusColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: formFocusColor),
          borderRadius: formBorderRadius,
        ),
        border: OutlineInputBorder(
          borderRadius: formBorderRadius,
        ),
        labelText: formHintText,
        labelStyle: TextStyle(color: labelTextColor),
      ),
    );
  }
}
