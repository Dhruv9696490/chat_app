import 'package:chat_app/core/error/exception.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/auth/data/dataSources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/model/user_model.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImple implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImple({
    required this.authRemoteDataSource,
  });

  @override
  Future<Either<Failure, UserModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final user = await authRemoteDataSource.signIn(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await authRemoteDataSource.signUp(
        email: email,
        password: password,
        name: name,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, UserModel>> currentUser() async {
    try {
      final userData = await authRemoteDataSource.getCurrentUserData();
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
  Future<Either<Failure, void>> signOut() async {
    try {
       authRemoteDataSource.signOut;
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
