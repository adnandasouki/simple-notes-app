import 'package:flutter/material.dart';

Widget noteContentWidget({
  required BuildContext context,
  required ScrollController scrollController,
  required TextEditingController contentController,
  Color? color,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 450,
    padding: EdgeInsets.only(left: 10, right: 7),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black54,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      color: color,
      border: Border.all(width: 1.5, color: Colors.black),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: Scrollbar(
      controller: scrollController,
      thumbVisibility: false,
      child: SingleChildScrollView(
        controller: scrollController,
        // input
        child: TextFormField(
          controller: contentController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Start Typing...',
          ),
        ),
      ),
    ),
  );
}
