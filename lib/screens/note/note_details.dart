import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:usertrack/db/notes_db_helper.dart';
import 'package:usertrack/screens/note/customize_on_view.dart';
import 'package:usertrack/widgets/note_widget.dart';

class NoteDetails extends StatefulWidget {
  const NoteDetails({
    super.key,
    required this.docid,
    required this.currentTitle,
    required this.currentContent,
    required this.color,
  });

  final String docid;
  final String currentTitle;
  final String currentContent;
  final Color color;

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  late TextEditingController title;
  late TextEditingController content;
  ScrollController scrollController = ScrollController();
  NotesDbHelper notesDbHelper = NotesDbHelper();

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.currentTitle);
    content = TextEditingController(text: widget.currentContent);
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
      color: widget.color,
      customizeButton: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomizeOnView(docid: widget.docid),
          ),
        );

        if (result == 'updated') {
          setState(() {});
        }
      },
      scrollController: scrollController,
      appbarTitle: 'Note Details',
      buttonText: 'Save Changes',
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
        await notesDbHelper.updateNote(
          docid: widget.docid,
          title: title.text,
          content: content.text,
        );
        Navigator.pop(context, 'updated');
      },
    );
  }
}
