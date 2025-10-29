part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess({required this.user});
}

final class AuthFailure extends AuthState {
  final String error;

  AuthFailure([this.error = 'something went wrong']);
}

final class AuthAllUser extends AuthState {
  final List<User> list;

  AuthAllUser(this.list);
}
