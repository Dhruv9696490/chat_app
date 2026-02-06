class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final bool isEdited;
  final DateTime timestamp;

  const Message({
    required this.isEdited,
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });
}
