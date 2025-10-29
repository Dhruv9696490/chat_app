import 'package:chat_app/core/error/exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

abstract interface class AuthRemoteDataSource {
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<UserCredential> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<User?> getCurrentUserData();

  Future<List<User>> getAllUsers();
}

class AuthRemoteDataSourceImple implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImple({required this.auth, required this.firestore});

  @override
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw ServerException("user is empty");
      }
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
      });
      return userCredential;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw ServerException("user is empty");
      }
      return userCredential;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<User?> getCurrentUserData() async {
    try {
      final user = auth.currentUser;
      final userName = await firestore.collection('users').doc(user?.uid).get();
      if (!userName.exists) {
        return null;
      }
      if (user == null) {
        return null;
      } else {
        return User(
          uid: user.uid,
          email: user.email ?? "",
          name: userName.data()!['name'],
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final snapshot = await firestore.collection('users').get();
      return snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
