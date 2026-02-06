part of 'users_bloc.dart';

@immutable
sealed class UsersBlocState {}

final class UsersBlocInitial extends UsersBlocState {}

final class UsersBlocLoading extends UsersBlocState {}

final class UsersBlocSuccess extends UsersBlocState {
  final List<User> users;
  UsersBlocSuccess({required this.users});
}

final class UsersBlocFailure extends UsersBlocState {
  final String message;
  UsersBlocFailure(this.message);
}
