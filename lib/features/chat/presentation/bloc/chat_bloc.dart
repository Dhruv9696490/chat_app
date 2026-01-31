import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/messages.dart';
import '../../domain/usecase/get_message.dart';
import '../../domain/usecase/send_message.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage _sendMessage;
  final GetMessages _getMessages;

  ChatBloc({required SendMessage sendMessage, required GetMessages getMessages})
    : _sendMessage = sendMessage,
      _getMessages = getMessages,
      super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      final result = await _sendMessage(event.message);
      result.fold((failure) => emit(ChatError(failure.error)), (_) {});
    });

    on<GetMessagesEvent>((event, emit) async {
      emit(ChatLoading());
      final stream = _getMessages(event.currentUserId, event.receiverId);
      stream.fold((l)=> emit(ChatError(l.error)) , (r){
        emit.forEach(r, onData: (messages)=> ChatLoaded(messages) );
      });
    });
  }
}
