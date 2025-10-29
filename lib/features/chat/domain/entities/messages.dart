class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'receiverId': receiverId,
    'text': text,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };

  factory Message.fromMap(Map<String, dynamic> map, String id) => Message(
    id: id,
    senderId: map['senderId'],
    receiverId: map['receiverId'],
    text: map['text'],
    timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
  );
}
