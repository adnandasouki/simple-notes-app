import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 400,
  });

  final String text;
  final void Function()? onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: width,
        color: Colors.blue,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
