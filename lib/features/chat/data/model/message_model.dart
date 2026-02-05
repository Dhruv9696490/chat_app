import 'package:chat_app/features/chat/domain/entities/messages.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.text,
    required super.timestamp,
  });
  Map<dynamic, dynamic> toJson() => {
    'senderId': senderId,
    'receiverId': receiverId,
    'text': text,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };
Map<dynamic, dynamic> toJsonForHive() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'text': text,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };
  factory MessageModel.fromJson(Map<dynamic, dynamic> map, String? id) => MessageModel(
    id: id ?? map['id'] ?? '',
    senderId: map['senderId'] ?? '',
    receiverId: map['receiverId'] ?? '',
    text: map['text'] ?? '',
    timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
  );
}
