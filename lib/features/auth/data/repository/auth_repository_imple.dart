import 'package:chat_app/core/error/exception.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImple implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImple(this.authRemoteDataSource);

  @override
  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      final user = await authRemoteDataSource.signIn(
        email: email,
        password: password,
      );
      final userName = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user!.uid)
          .get();
      return right(
        User(
          uid: user.user!.uid,
          email: email,
          name: userName['name'] ?? "name not fount",
        ),
      );
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Future<void> signOut() async {
    await authRemoteDataSource.signOut();
  }

  @override
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await authRemoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
      );
      return right(
        User(uid: userCredential.user!.uid, email: email, name: name),
      );
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final User? userData = await authRemoteDataSource.getCurrentUserData();
      if (userData == null) {
        return left(Failure("user is null"));
      } else {
        return right(userData);
      }
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    try {
      final result = await authRemoteDataSource.getAllUsers();
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }
}
