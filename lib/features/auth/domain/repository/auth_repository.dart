import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  );

  Future<Either<Failure, User>> signIn(String email, String password);

  Future<void> signOut();

  Future<Either<Failure, User>> currentUser();

  Future<Either<Failure, List<User>>> getAllUsers();
}
