import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

enum WsConnectionStatus { disconnected, connecting, connected }

class ChatWebSocketState {
  final WsConnectionStatus status;
  final String currentUserId;
  final String activeRoomId;
  final List<ChatMessage> messages;
  final List<ConversationItem> conversations;

  const ChatWebSocketState({
    this.status = WsConnectionStatus.disconnected,
    this.currentUserId = '',
    this.activeRoomId = '',
    this.messages = const [],
    this.conversations = const [],
  });

  bool get isConnected => status == WsConnectionStatus.connected;

  ChatWebSocketState copyWith({
    WsConnectionStatus? status,
    String? currentUserId,
    String? activeRoomId,
    List<ChatMessage>? messages,
    List<ConversationItem>? conversations,
  }) {
    return ChatWebSocketState(
      status: status ?? this.status,
      currentUserId: currentUserId ?? this.currentUserId,
      activeRoomId: activeRoomId ?? this.activeRoomId,
      messages: messages ?? this.messages,
      conversations: conversations ?? this.conversations,
    );
  }
}