import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotesDbHelper {
  CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  Future<void> createNote({
    required String title,
    required String content,
    Color color = Colors.white,
  }) async {
    notes.add({
      'title': title,
      'content': content,
      'color': color.toARGB32(),
      'creationDate': DateTime.now(),
      'modificationDate': DateTime.now(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> deleteNote({required String docid}) async {
    await notes.doc(docid).delete();
  }

  Future<void> deleteSelectedNotes(List<String> list) async {
    final collection = await notes.get();

    for (var doc in collection.docs) {
      if (list.contains(doc.id)) {
        await doc.reference.delete();
      }
    }
  }

  Future<void> updateNote({
    required String docid,
    String? title,
    String? content,
    Color? color,
  }) async {
    final Map<String, dynamic> list = {};

    if (title != null) list['title'] = title;
    if (content != null) list['content'] = content;
    if (color != null) list['color'] = color.toARGB32();
    list['modificationDate'] = DateTime.now();

    if (list.isNotEmpty) {
      await notes.doc(docid).update(list);
    }
  }
}
