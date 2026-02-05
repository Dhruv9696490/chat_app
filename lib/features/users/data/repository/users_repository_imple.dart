import 'package:chat_app/core/error/exception.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/network/connection_checker.dart';
import 'package:chat_app/features/users/data/dataSource/users_local_data_source.dart';
import 'package:chat_app/features/users/data/dataSource/users_remote_data_source.dart';
import 'package:chat_app/features/users/data/model/user_model.dart';
import 'package:chat_app/features/users/domain/repository/users_repository.dart';
import 'package:fpdart/fpdart.dart';

class UsersRepositoryImple implements UsersRepository {
  final UsersRemoteDataSource userRemoteDataSource;
  final UsersLocalDataSource usersLocalDataSource;
  final ConnectionChecker connectionChecker;
  UsersRepositoryImple({
    required this.connectionChecker,
    required this.usersLocalDataSource,
    required this.userRemoteDataSource,
  });
  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      if (!(await connectionChecker.isConnected())) {
        final res = await usersLocalDataSource.getAllUsers();
        return right(res);
      }
      final result = await userRemoteDataSource.getAllUsers();
      await usersLocalDataSource.uploadUsers(users: result);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }
}
