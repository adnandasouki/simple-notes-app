import 'package:flutter/material.dart';
import 'package:usertrack/db/notes_db_helper.dart';
import 'package:usertrack/screens/note/note_details.dart';
import 'package:usertrack/screens/note/notes.dart';
import 'package:usertrack/widgets/custom_material_button.dart';

class CustomizeOnView extends StatelessWidget {
  CustomizeOnView({super.key, required this.docid});

  String docid;
  Color noteColor = Colors.white;

  NotesDbHelper notesDbHelper = NotesDbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 4,
        title: Text('Customize Note', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text('Note Color'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // light blue accent
                InkWell(
                  onTap: () {
                    noteColor = Colors.white;

                    if (noteColor == Colors.white) {
                      print('color is white');
                    } else {
                      print('is not white');
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    noteColor = Colors.redAccent;
                    if (noteColor == Colors.redAccent) {
                      print('color is redaccent');
                    } else {
                      print('is not white');
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    noteColor = Colors.lightGreenAccent;
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),

            GestureDetector(
              onTap: () {
                notesDbHelper.updateNote(docid: docid, color: noteColor);
                Navigator.pop(context, 'updated');
              },
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
                  'Save Changes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
