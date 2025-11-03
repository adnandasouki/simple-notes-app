import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  CustomInputField({
    super.key,
    this.hintText,
    required this.controller,
    this.color = Colors.white,
  });

  final String? hintText;
  final TextEditingController controller;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        // note color
        color: color,

        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
    );
  }
}
