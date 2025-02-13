import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  const AuthFormField({
    super.key,
    required this.formFocusColor,
    required this.formHintText,
    this.formBackgroundColor = Colors.white,
    this.hintTextColor = Colors.grey,
    this.labelTextColor = Colors.black,
    this.formBorderRadius = 30,
    this.formPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    this.obscureText = false,
    required this.controller,
    required this.validator,
  });

  final Color formFocusColor;
  final double formBorderRadius;
  final String formHintText;
  final Color labelTextColor;
  final Color formBackgroundColor;
  final Color hintTextColor;
  final EdgeInsetsGeometry formPadding;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), // Adds spacing between fields
      decoration: BoxDecoration(
        color: formBackgroundColor,
        borderRadius: BorderRadius.circular(formBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obscureText,
        validator: validator,
        controller: controller,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          contentPadding: formPadding,
          focusColor: formFocusColor,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: formFocusColor),
            borderRadius: BorderRadius.circular(formBorderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(formBorderRadius),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(formBorderRadius),
          ),
          hintText: formHintText,
          hintStyle: TextStyle(color: hintTextColor),
          labelText: formHintText,
          labelStyle: TextStyle(color: labelTextColor),
        ),
      ),
    );
  }
}
