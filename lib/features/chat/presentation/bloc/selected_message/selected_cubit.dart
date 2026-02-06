import 'package:chat_app/features/chat/domain/entities/messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedCubit extends Cubit<Message?> {
  SelectedCubit() : super(null);
  void newMessage(Message messsage) {
    emit(messsage);
  }

  void deleteMessage() {
    emit(null);
  }
}
