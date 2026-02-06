import 'package:chat_app/core/cubit/currentUser/current_user_cubit.dart';
import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/features/auth/domain/usecase/signout.dart';
import 'package:chat_app/features/auth/domain/usecase/user_login.dart';
import 'package:chat_app/features/auth/domain/usecase/user_sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/usecase/get_current_user.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final SignOut _signOut;
  final GetCurrentUser _isUserSignUp;
  final CurrentUserCubit _currentUserCubit;

  AuthBloc({
    required userSignUp,
    required userLogin,
    required signOut,
    required isUserSignUp,
    required currentUserCubit,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _signOut = signOut,
       _isUserSignUp = isUserSignUp,
       _currentUserCubit = currentUserCubit,
       super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      final result = await _userSignUp(
        SignUpParam(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );
      result.fold((onLeft) => emit(AuthFailure(onLeft.error)), (onRight) {
        _currentUserCubit.updateUser(onRight);
        emit(AuthSuccess(user: onRight));
      });
    });
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      final result = await _userLogin(
        LoginParam(email: event.email, password: event.password),
      );
      result.fold((onLeft) => emit(AuthFailure(onLeft.error)), (onRight) {
        _currentUserCubit.updateUser(onRight);
        emit(AuthSuccess(user: onRight));
      });
    });
    on<AuthSignOut>((event, emit) async {
      await _signOut(NoParams());
      _currentUserCubit.updateUser(null);
      emit(AuthUnathenticated());
    });
    on<AuthGetCurrentUser>((event, emit) async {
      emit(AuthLoading());
      final Either<Failure, User> result = await _isUserSignUp(NoParams());
      result.fold((l) => emit(AuthUnathenticated()), (onRight) {
        _currentUserCubit.updateUser(onRight);
        emit(AuthSuccess(user: onRight));
      });
    });
  }
}
