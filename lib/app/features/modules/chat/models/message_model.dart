
enum MessageStatus {
  sent,
  delivered,
  seen,
}

class MessageModel {
  final String id;
  final String text;
  final bool isMe; // true if the message is from the customer (user)
  final DateTime timestamp;
  final MessageStatus status; // only applies if isMe is true

  MessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });
}
