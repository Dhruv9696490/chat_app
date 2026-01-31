import 'package:chat_app/core/entities/user.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/features/users/domain/useCase/get_all_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'users_bloc_event.dart';
part 'users_bloc_state.dart';

class UsersBloc extends Bloc<UsersBlocEvent, UsersBlocState> {
  final GetAllUser _getAllUser;
  UsersBloc({required getAllUser})
    : _getAllUser = getAllUser,
      super(UsersBlocInitial()) {
    on<GetAllUsersEvent>((event, emit) async {
      emit(UsersBlocLoading());
      final res = await _getAllUser(NoParams());
      res.fold((l) => emit(UsersBlocFailure(l.error)), (r)=> emit(UsersBlocSuccess(users: r)));
    });
  }
}
