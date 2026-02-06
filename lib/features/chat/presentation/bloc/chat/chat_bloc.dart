import 'package:chat_app/features/chat/domain/usecase/delete_message.dart';
import 'package:chat_app/features/chat/domain/usecase/update_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/messages.dart';
import '../../../domain/usecase/get_message.dart';
import '../../../domain/usecase/send_message.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage _sendMessage;
  final GetMessages _getMessages;
  final DeleteMessage _deleteMessage;
  final UpdateMessage _updateMessage;

  ChatBloc({
    required SendMessage sendMessage,
    required GetMessages getMessages,
    required DeleteMessage deleteMessage,
    required UpdateMessage updateMessage,
  }) : _sendMessage = sendMessage,
       _getMessages = getMessages,
       _deleteMessage = deleteMessage,
       _updateMessage = updateMessage,
       super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      final result = await _sendMessage(event.message);
      result.fold((failure) => emit(ChatError(failure.error)), (_) {});
    });
    on<DeleteMessageEvent>((event, emit) async {
      final result = await _deleteMessage(event.message);
      result.fold((failure) => emit(ChatError(failure.error)), (_) {});
    });
    on<UpdateMessageEvent>((event, emit) async {
      final result = await _updateMessage(event.message);
      result.fold((failure) => emit(ChatError(failure.error)), (_) {});
    });
    on<GetMessagesEvent>((event, emit) async {
      emit(ChatLoading());
      final stream = await _getMessages(event.currentUserId, event.receiverId);
      stream.fold((l) => emit(ChatError(l.error)), (r) async{
        await emit.forEach(r, onData: (messages) => ChatLoaded(messages));
      });
    });
  }
}
