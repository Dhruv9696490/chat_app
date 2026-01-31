import 'package:chat_app/core/error/exception.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/features/users/data/dataSource/user_remote_data_source.dart';
import 'package:chat_app/features/users/data/model/user_model.dart';
import 'package:chat_app/features/users/domain/repository/users_repository.dart';
import 'package:fpdart/fpdart.dart';

class UsersRepositoryImple implements UsersRepository {
  final UserRemoteDataSource userRemoteDataSource;
  UsersRepositoryImple({required this.userRemoteDataSource});
   @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      final result = await userRemoteDataSource.getAllUsers();
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }
}
