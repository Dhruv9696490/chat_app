import 'package:chat_app/core/error/exception.dart';
import 'package:chat_app/features/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> signIn({required String email, required String password});

  Future<void> signOut();

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImple implements AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImple({required this.auth, required this.firestore});

  @override
  Future<UserModel> signUp({
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
        throw ServerException("User Is Not Logged IN");
      }
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': userCredential.user!.uid,
      });
      return UserModel(uid: userCredential.user!.uid, email: email, name: name);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw ServerException("User can't login");
      }
      final userDoc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return UserModel(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc.data()?['name'] ?? "not found",
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
       await auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
   
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return null;
      }
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (userDoc.data() == null) {
        return null;
      }
      return UserModel(
        uid: user.uid,
        email: user.email ?? "",
        name: userDoc.data()?['name'] ?? "not found",
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
