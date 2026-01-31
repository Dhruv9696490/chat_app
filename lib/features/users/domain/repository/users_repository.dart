 import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UsersRepository {
  Future<Either<Failure, List<User>>> getAllUsers();
}


