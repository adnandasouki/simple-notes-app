import 'package:flutter/material.dart';
import 'package:usertrack/widgets/custom_input_field.dart';
import 'package:usertrack/widgets/note_content_widget.dart';

class NoteWidget extends StatefulWidget {
  const NoteWidget({
    super.key,
    required this.title,
    required this.content,
    required this.scrollController,
    required this.onPressed,
    required this.buttonText,
    required this.customizeButton,
    required this.appbarTitle,
    this.color = Colors.white,
  });

  final TextEditingController title;
  final TextEditingController content;
  final ScrollController scrollController;
  final Function() onPressed;
  final String buttonText;
  final Function() customizeButton;
  final String appbarTitle;
  final Color color;

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 4,
        title: Text(widget.appbarTitle, style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actionsPadding: EdgeInsets.only(right: 10),
        actionsIconTheme: IconThemeData(size: 30),
        actions: [
          // customize note
          IconButton(
            onPressed: widget.customizeButton,
            icon: Icon(
              Icons.color_lens_outlined,
              color: Colors.black54,
              size: 25,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),

                // title
                CustomInputField(
                  controller: widget.title,
                  hintText: 'Title',
                  color: widget.color,
                ),
                SizedBox(height: 15),

                // content
                noteContentWidget(
                  context: context,
                  scrollController: widget.scrollController,
                  contentController: widget.content,
                  color: widget.color,
                ),
                SizedBox(height: 15),

                // Create note button
                GestureDetector(
                  onTap: widget.onPressed,
                  child: Container(
                    alignment: Alignment.center,
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      // note color
                      color: Colors.blueAccent,
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      widget.buttonText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
