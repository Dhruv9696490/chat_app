import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit() : super(CurrentUserInitial());
}
