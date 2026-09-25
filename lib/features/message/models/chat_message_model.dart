import 'package:intl/intl.dart';

class ChatMessage {
  final String content;
  final String? fileUrl;
  final String createdAt;
  final String user1Id;
  final bool isSender;
  final String formattedTime;

  const ChatMessage({
    required this.content,
    this.fileUrl,
    required this.createdAt,
    required this.user1Id,
    required this.isSender,
    required this.formattedTime,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, String currentUserId) {
    final String senderId = (map['user1Id'] ?? map['userId'] ?? '').toString();
    final String created = (map['createdAt'] ?? '').toString();
    final bool isUserSender = currentUserId.isNotEmpty && senderId == currentUserId;

    String? parsedFile;
    if (map['fileUrl'] is List && (map['fileUrl'] as List).isNotEmpty) {
      parsedFile = (map['fileUrl'] as List).first.toString();
    } else if (map['fileUrl'] is String && (map['fileUrl'] as String).isNotEmpty) {
      parsedFile = map['fileUrl'] as String;
    }

    String formatted = '';
    if (created.isNotEmpty) {
      try {
        final dt = DateTime.parse(created).toLocal();
        formatted = DateFormat('hh:mm a').format(dt);
      } catch (_) {}
    }

    return ChatMessage(
      content: (map['content'] ?? '').toString(),
      fileUrl: parsedFile,
      createdAt: created,
      user1Id: senderId,
      isSender: isUserSender,
      formattedTime: formatted,
    );
  }
}