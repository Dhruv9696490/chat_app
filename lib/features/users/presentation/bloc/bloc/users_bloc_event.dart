part of 'users_bloc.dart';

@immutable
sealed class UsersBlocEvent {}

final class GetAllUsersEvent extends UsersBlocEvent{}