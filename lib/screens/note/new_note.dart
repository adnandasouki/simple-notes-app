import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:usertrack/db/notes_db_helper.dart';
import 'package:usertrack/screens/note/notes.dart';
import 'package:usertrack/screens/note/customize_on_create.dart';
import 'package:usertrack/widgets/note_widget.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  ScrollController scrollController = ScrollController();
  NotesDbHelper notesDbHelper = NotesDbHelper();

  Color selectedColor = Colors.white;

  void pickColor() async {
    final newColor = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomizeOnCreate(initialColor: selectedColor),
      ),
    );

    if (newColor != null) {
      setState(() {
        selectedColor = newColor;
      });
    }
  }

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NoteWidget(
      title: title,
      content: content,
      customizeButton: () {
        pickColor();
      },
      scrollController: scrollController,
      appbarTitle: 'New Note',
      buttonText: 'Create Note',
      onPressed: () async {
        if (title.text.trim().isEmpty) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Please enter a name for the category.',
          ).show();
          return;
        }
        print('note created');
        notesDbHelper.createNote(
          title: title.text,
          content: content.text,
          color: selectedColor,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Notes()),
          (route) => false,
        );
      },
    );
  }
}
