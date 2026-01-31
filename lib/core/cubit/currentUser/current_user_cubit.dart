import 'package:chat_app/core/entities/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit() : super(CurrentUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(CurrentUserLoggedOut());
    } else {
      emit(CurrentUserLoggedIn(user: user));
    }
  }
}
