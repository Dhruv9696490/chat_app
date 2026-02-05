import 'package:chat_app/core/constant/constant.dart';
import 'package:chat_app/core/network/connection_checker.dart';
import 'package:chat_app/features/chat/data/dataSource/chat_local_data_source.dart';
import 'package:chat_app/features/chat/data/model/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/messages.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repository/chat_repository.dart';
import '../dataSource/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  final ChatLocalDataSource localDataSource;
  ChatRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
    this.localDataSource,
  );

  @override
  Future<Either<Failure, Stream<List<Message>>>> getMessages(
    String currentUserId,
    String receiverId,
  ) async {
    try {
      if (!(await connectionChecker.isConnected())) {
        print(
          "offline //////////////||||||||||\\\\\\\\\\\\===========================",
        );
        final list = await localDataSource.getAllMessage();
        if (list.isEmpty) {
          return left(Failure('No message found'));
        }
        final newList = list.where((item) {
          return ((item.receiverId == currentUserId &&
                  item.senderId == receiverId) ||
              (item.senderId == currentUserId &&
                  item.receiverId == receiverId));
        }).toList();
        print(
          "${newList[0].text} offline //////////////||||||||||\\\\\\\\\\\\==============================",
        );
        newList.sort((a, b) {
          return b.timestamp.compareTo(a.timestamp);
        });
        return right(Stream<List<Message>>.fromIterable([newList]));
        // right(Stream.value(newList));
      }
      final res = remoteDataSource.getMessages(currentUserId, receiverId);
      localDataSource.uploadMessage(messages: await res.first);
      print(
        "${res.first.toString()} //////////////||||||||||\\\\\\\\\\\\==============================",
      );
      return right(res);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    try {
      if (!(await connectionChecker.isConnected())) {
        return left(Failure(Constant.offlineMessage));
      }
      await remoteDataSource.sendMessage(
        MessageModel(
          id: message.id,
          senderId: message.senderId,
          receiverId: message.receiverId,
          text: message.text,
          timestamp: message.timestamp,
        ),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteMessage(Message message)async {
     try {
      if (!(await connectionChecker.isConnected())) {
        return left(Failure(Constant.offlineMessage));
      }
      await remoteDataSource.deleteMessage(
        MessageModel(
          id: message.id,
          senderId: message.senderId,
          receiverId: message.receiverId,
          text: message.text,
          timestamp: message.timestamp,
        ),
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.error));
    }
  }
}
