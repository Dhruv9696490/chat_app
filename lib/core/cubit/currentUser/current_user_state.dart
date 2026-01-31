part of 'current_user_cubit.dart';

sealed class CurrentUserState {}

final class CurrentUserInitial extends CurrentUserState {}
final class CurrentUserLoggedOut extends CurrentUserState {}

final class CurrentUserLoggedIn extends CurrentUserState {
  final User user;
  CurrentUserLoggedIn({required this.user});
}

