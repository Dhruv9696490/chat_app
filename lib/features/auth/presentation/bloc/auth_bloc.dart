import 'package:chat_app/core/error/exception.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/auth/domain/entities/user.dart';
import 'package:chat_app/features/auth/domain/usecase/get_all_user.dart';
import 'package:chat_app/features/auth/domain/usecase/signout.dart';
import 'package:chat_app/features/auth/domain/usecase/user_login.dart';
import 'package:chat_app/features/auth/domain/usecase/user_signUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/usecase/is_user_signUp.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final SignOut _signOut;
  final IsUserSignUp _isUserSignUp;
  final GetAllUser _getAllUser;

  AuthBloc({
    required userSignUp,
    required userLogin,
    required signOut,
    required isUserSignUp,
    required getAllUser,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _signOut = signOut,
       _isUserSignUp = isUserSignUp,
       _getAllUser = getAllUser,
       super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
    });
    on<AuthSignUp>((event, emit) async {
      final result = await _userSignUp(
        SignUpParam(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );
      result.fold(
        (onLeft) => emit(AuthFailure(onLeft.error)),
        (onRight) => emit(AuthSuccess(user: onRight)),
      );
    });
    on<AuthLogin>((event, emit) async {
      final result = await _userLogin(
        LoginParam(email: event.email, password: event.password),
      );
      result.fold((onLeft) => emit(AuthFailure(onLeft.error)), (onRight) {
        return emit(AuthSuccess(user: onRight));
      });
    });
    on<AuthSignOut>((event, emit) async {
      await _signOut(NoParams());
      emit(AuthInitial());
    });
    on<AuthGetCurrentUser>((event, emit) async {
      final Either<Failure, User> result = await _isUserSignUp(NoParams());
      result.fold(
        (l) => emit(AuthInitial()),
        (r) => emit(AuthSuccess(user: r)),
      );
    });
    on<AuthGetAllUser>((event, emit) async {
      try {
        final Either<Failure, List<User>> userList = await _getAllUser(
          NoParams(),
        );
        userList.fold(
          (l) => emit(AuthFailure(l.error)),
          (r) => emit(AuthAllUser(r)),
        );
      } on ServerException catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
