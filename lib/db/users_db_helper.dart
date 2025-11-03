import 'package:cloud_firestore/cloud_firestore.dart';

class UsersDbHelper {
  CollectionReference usersCollection = FirebaseFirestore.instance.collection(
    'users',
  );

  Future<void> createUser({
    required String id,
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String email,
  }) async {
    await usersCollection.add({
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'email': email,
    });
  }

  Future<void> updateUser({
    String? firstName,
    String? lastName,
    String? username,
    String? password,
    String? email,
    required String userDocumentId,
  }) async {
    usersCollection.doc(userDocumentId).update({
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'email': email,
    });
  }
}
