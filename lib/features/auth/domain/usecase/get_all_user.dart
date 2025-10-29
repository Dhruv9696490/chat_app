import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllUser implements UseCase<List<User>, NoParams> {
  final AuthRepository authRepository;

  GetAllUser(this.authRepository);

  @override
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await authRepository.getAllUsers();
  }
}
