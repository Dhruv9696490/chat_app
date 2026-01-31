import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class UserLogin implements UseCase<User, LoginParam> {
  final AuthRepository authRepository;

  UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(LoginParam params) async {
    return await authRepository.signIn(params.email, params.password);
  }
}

class LoginParam {
  final String email;
  final String password;

  LoginParam({required this.email, required this.password});
}
