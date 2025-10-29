import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class UserSignUp implements UseCase<User, SignUpParam> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(SignUpParam params) async {
    return await authRepository.signUp(
      params.name,
      params.email,
      params.password,
    );
  }
}

class SignUpParam {
  final String name;
  final String email;
  final String password;

  SignUpParam({
    required this.name,
    required this.email,
    required this.password,
  });
}
