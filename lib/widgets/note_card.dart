import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatefulWidget {
  NoteCard({
    super.key,
    required this.docid,
    required this.title,
    required this.content,
    required this.creationDate,
    this.color,
    this.onLongPress,
    this.onTap,
    required this.footerWidget,
  });

  final String docid;
  final String title;
  final String content;
  final Timestamp creationDate;
  final Color? color;
  void Function()? onLongPress;
  void Function()? onTap;
  Widget footerWidget;

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // on long press
      onLongPress: widget.onLongPress,

      // on click
      onTap: widget.onTap,

      // note container
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          // note color
          color: widget.color,
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            // content
            Text(
              widget.content,
              style: TextStyle(
                fontSize: 15,
                color: const Color.fromARGB(255, 60, 60, 60),
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            // date
            widget.footerWidget,
          ],
        ),
      ),
    );
  }
}
