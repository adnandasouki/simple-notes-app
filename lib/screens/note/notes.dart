import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:usertrack/db/notes_db_helper.dart';
import 'package:usertrack/screens/note/new_note.dart';
import 'package:usertrack/screens/note/note_details.dart';
import 'package:usertrack/screens/settings_screen.dart';
import 'package:usertrack/widgets/custom_search_bar.dart';
import 'package:usertrack/widgets/note_card.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  NotesDbHelper notesDbHelper = NotesDbHelper();
  List<QueryDocumentSnapshot> notesList = [];
  List<QueryDocumentSnapshot> searchResaultsList = [];

  bool isSearching = false;
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();

  bool selectionMode = false;
  List<String> selections = [];
  bool isSelected = false;
  bool allSelected = false;

  String initSort = 'creationDate';

  bool isLoading = true;

  void startSeach() {
    isSearching = true;
    searchFocusNode.requestFocus();
    handleSearch();
    setState(() {});
  }

  void stopSearch() {
    isSearching = false;
    searchFocusNode.unfocus();
    searchController.clear();
    setState(() {});
  }

  Future<void> handleSearch() async {
    searchResaultsList = [];

    if (searchController.text == '') {
      searchResaultsList = [...notesList];
    } else {
      for (int i = 0; i < notesList.length; i++) {
        if (notesList[i]['title'].contains(searchController.text)) {
          searchResaultsList.add(notesList[i]);
          print('search match: ${notesList[i]['title']}');
        }
      }
    }
    print('controller: ${searchController.text}');

    setState(() {});
  }

  Future<void> getAllNotes() async {
    CollectionReference notes = FirebaseFirestore.instance.collection('notes');
    QuerySnapshot docSnapthots =
        await notes
            .orderBy(initSort, descending: true)
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
    notesList.addAll(docSnapthots.docs);

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllNotes();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      // Appbar
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 4,
        centerTitle: true,
        title:
            selectionMode
                ? Text(
                  '${selections.length} Selected',
                  style: TextStyle(color: Colors.black54),
                )
                : Icon(Icons.note_alt_outlined, size: 42),
        actionsPadding: EdgeInsets.only(right: 10),
        actionsIconTheme: IconThemeData(size: 30),
        actions: [
          selectionMode
              ? Row(
                children: [
                  // delete
                  IconButton(
                    onPressed: () async {
                      await notesDbHelper.deleteSelectedNotes(selections);
                      selections.clear();
                      notesList.clear();
                      selectionMode = false;
                      setState(() {
                        getAllNotes();
                      });
                    },
                    icon: Icon(Icons.delete_outline, color: Colors.black54),
                  ),
                  // select/unselect all
                  IconButton(
                    icon:
                        allSelected
                            ? Icon(Icons.select_all, color: Colors.red)
                            : Icon(Icons.select_all, color: Colors.black54),
                    onPressed: () async {
                      if (!allSelected) {
                        final collection =
                            await FirebaseFirestore.instance
                                .collection('notes')
                                .get();

                        for (var doc in collection.docs) {
                          if (!selections.contains(doc.id)) {
                            selections.add(doc.id);
                          }
                        }

                        allSelected = true;
                      } else {
                        selections.clear();
                        allSelected = false;
                      }

                      setState(() {});
                    },
                  ),
                  // cancel
                  IconButton(
                    icon: Icon(Icons.cancel_outlined, color: Colors.black54),
                    onPressed: () {
                      selectionMode = false;
                      selections = [];
                      setState(() {});
                    },
                  ),
                ],
              )
              // settings
              : IconButton(
                onPressed: () async {
                  final sortResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(sort: initSort),
                    ),
                  );
                  setState(() {
                    initSort = sortResult;
                    notesList.clear();
                  });

                  getAllNotes();
                },
                icon: Icon(Icons.settings_outlined, color: Colors.black54),
              ),
        ],
      ),
      // Body
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            // Search Container
            Row(
              children: [
                Expanded(
                  // Search Bar
                  child: CustomSearchBar(
                    controller: searchController,
                    focusNode: searchFocusNode,
                    onTap: () {
                      startSeach();
                    },
                    onChanged: (q) {
                      handleSearch();
                    },
                  ),
                ),

                isSearching
                    ? IconButton(
                      onPressed: () {
                        stopSearch();
                      },
                      icon: Icon(Icons.cancel, color: Colors.red),
                    )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 20),
            // Notes List
            !isSearching
                ? isLoading == true
                    ? Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                    : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: notesList.length,
                        itemBuilder: (context, i) {
                          // note card
                          return NoteCard(
                            docid: notesList[i].id,
                            title: notesList[i]['title'],
                            content: notesList[i]['content'],
                            creationDate: notesList[i]['creationDate'],
                            color: Color(notesList[i]['color']),
                            // long press
                            onLongPress: () {
                              selectionMode = true;
                              if (!selections.contains(notesList[i].id)) {
                                selections.add(notesList[i].id);
                                isSelected = true;
                                print('note selected');
                              } else {
                                print('note is already selected');
                              }

                              print('Selections: $selections');

                              setState(() {});
                            },
                            // tap
                            onTap: () async {
                              if (selectionMode) {
                                if (!selections.contains(notesList[i].id)) {
                                  selections.add(notesList[i].id);
                                  print('note selected');
                                } else {
                                  selections.remove(notesList[i].id);
                                  print('note unselected');
                                }
                              } else {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => NoteDetails(
                                          docid: notesList[i].id,
                                          currentTitle: notesList[i]['title'],
                                          currentContent:
                                              notesList[i]['content'],
                                          color: Color(notesList[i]['color']),
                                        ),
                                  ),
                                );

                                if (result == 'updated') {
                                  notesList.clear();
                                  getAllNotes();
                                  setState(() {});
                                }
                              }
                              print('Selections: $selections');

                              setState(() {});
                            },
                            footerWidget:
                                isSelected
                                    ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // date
                                        initSort == 'creationDate'
                                            ? Text(
                                              DateFormat(
                                                'dd/MM/yyy, HH:mm',
                                              ).format(
                                                notesList[i]['creationDate']
                                                    .toDate(),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            )
                                            : Text(
                                              DateFormat(
                                                'dd/MM/yyy, HH:mm',
                                              ).format(
                                                notesList[i]['modificationDate']
                                                    .toDate(),
                                              ),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),

                                        // checkbox
                                        selections.contains(notesList[i].id)
                                            ? Icon(Icons.check_box)
                                            : SizedBox(),
                                      ],
                                    )
                                    : initSort == 'creationDate'
                                    ? Text(
                                      DateFormat('dd/MM/yyy, HH:mm').format(
                                        notesList[i]['creationDate'].toDate(),
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    )
                                    : Text(
                                      DateFormat('dd/MM/yyy, HH:mm').format(
                                        notesList[i]['modificationDate']
                                            .toDate(),
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                          );
                        },
                      ),
                    )
                : Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: searchResaultsList.length,
                    itemBuilder: (context, i) {
                      return NoteCard(
                        docid: searchResaultsList[i].id,
                        title: searchResaultsList[i]['title'],
                        content: searchResaultsList[i]['content'],
                        creationDate: notesList[i]['creationDate'],
                        color: Color(notesList[i]['color']),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => NoteDetails(
                                    docid: notesList[i].id,
                                    currentTitle: notesList[i]['title'],
                                    currentContent: notesList[i]['content'],
                                    color: Color(notesList[i]['color']),
                                  ),
                            ),
                          );
                        },
                        footerWidget:
                            isSelected
                                ? Row(
                                  children: [
                                    // date
                                    initSort == 'creationDate'
                                        ? Text(
                                          DateFormat('dd/MM/yyy, HH:mm').format(
                                            notesList[i]['creationDate']
                                                .toDate(),
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        )
                                        : Text(
                                          DateFormat('dd/MM/yyy, HH:mm').format(
                                            notesList[i]['modificationDate']
                                                .toDate(),
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                    Spacer(),
                                    // checkbox
                                    Icon(Icons.check_box),
                                  ],
                                )
                                : initSort == 'creationDate'
                                ? Text(
                                  DateFormat('dd/MM/yyy, HH:mm').format(
                                    notesList[i]['creationDate'].toDate(),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                )
                                : Text(
                                  DateFormat('dd/MM/yyy, HH:mm').format(
                                    notesList[i]['modificationDate'].toDate(),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
      // create a new note
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.black54,
        child: Icon(Icons.add, size: 30),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => NewNote()));
        },
      ),
    );
  }
}
