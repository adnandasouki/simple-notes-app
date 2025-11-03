import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onTap,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function() onTap;
  final Function(String query) onChanged;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,

      elevation: 4,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Search Notes',
          hintStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(Icons.search, color: Colors.black),
          contentPadding: EdgeInsets.all(18),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }
}
