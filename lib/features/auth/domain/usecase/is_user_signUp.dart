import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import '../repository/auth_repository.dart';

class IsUserSignUp implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  IsUserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
