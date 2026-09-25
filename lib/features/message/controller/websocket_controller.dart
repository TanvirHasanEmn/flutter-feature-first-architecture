import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';
import 'chat_websocket_state.dart';

class ChatWebSocketController extends Notifier<ChatWebSocketState> {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const String _wsUrl = 'ws://api.manospro/';
  String? _lastJoinedReceiverId;

  @override
  ChatWebSocketState build() {
    ref.onDispose(() {
      _cancelReconnect();
      _disconnect();
    });

    _init();
    return const ChatWebSocketState();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final myId = prefs.getString('myid') ?? '';
    state = state.copyWith(currentUserId: myId);
    connect();
  }

  Future<void> connect() async {
    _cancelReconnect();
    await _disconnect();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';

    if (token.isEmpty) {
      debugPrint('⚠️ No token found, skipping WebSocket connect');
      return;
    }

    try {
    //   state = state.copyWith(status: WsConnectionStatus.connecting);
    // //  _channel = IOWebSocketChannel.connect(
    //     Uri.parse(_wsUrl),
    //     headers: {'x-token': token},
    //     pingInterval: const Duration(seconds: 30),
    //   );

      _setupListeners();
      _reconnectAttempts = 0;
    } catch (e) {
      debugPrint('❌ WS Connection Error: $e');
      _handleDisconnection();
    }
  }

  void _setupListeners() {
    _channel?.stream.listen(
          (data) {
        if (!state.isConnected) {
          state = state.copyWith(status: WsConnectionStatus.connected);
          requestConversationList();
          if (_lastJoinedReceiverId != null) {
            joinRoom(_lastJoinedReceiverId!);
          }
        }

        try {
          final decoded = jsonDecode(data);
          _handleMessage(decoded);
        } catch (e) {
          debugPrint('❌ Error decoding message: $e');
        }
      },
      onDone: _handleDisconnection,
      onError: (error) {
        debugPrint('⚠️ WS Stream Error: $error');
        _handleDisconnection();
      },
      cancelOnError: true,
    );
  }

  void _handleMessage(dynamic data) {
    if (data is! Map<String, dynamic>) return;
    final type = data['type'];

    switch (type) {
      case 'past-messages':
        final List<dynamic> msgList = data['messages'] ?? [];
        final parsedMessages = msgList
            .whereType<Map<String, dynamic>>()
            .map((m) => ChatMessage.fromMap(m, state.currentUserId))
            .toList();

        state = state.copyWith(
          messages: parsedMessages,
          activeRoomId: data['roomId']?.toString() ?? '',
        );
        break;

      case 'member-new-message':
        final msgMap = data['message'] as Map<String, dynamic>?;
        if (msgMap != null) {
          final newMsg = ChatMessage.fromMap(msgMap, state.currentUserId);
          state = state.copyWith(
            messages: [newMsg, ...state.messages],
          );
        }
        break;

      case 'member-conversation':
        final List<dynamic> convoList = data['conversations'] ?? [];
        final convos = convoList
            .whereType<Map<String, dynamic>>()
            .map(ConversationItem.fromMap)
            .toList();

        state = state.copyWith(conversations: convos);
        break;
    }
  }

  void joinRoom(String receiverId) {
    _lastJoinedReceiverId = receiverId;
    if (!state.isConnected) return;

    final payload = {
      'type': 'member-subscribe',
      'receiverId': receiverId,
    };
    _channel?.sink.add(jsonEncode(payload));
  }

  void sendMessage({
    required String content,
    required String receiverId,
    List<String> fileUrls = const [],
  }) {
    if (!state.isConnected) return;

    final payload = {
      'type': 'member-send-message',
      'content': content,
      'receiverId': receiverId,
      'fileUrl': fileUrls,
    };
    _channel?.sink.add(jsonEncode(payload));
  }

  void requestConversationList() {
    if (!state.isConnected) return;
    _channel?.sink.add(jsonEncode({'type': 'member-conversation'}));
  }

  void _handleDisconnection() {
    if (state.isConnected) {
      state = state.copyWith(status: WsConnectionStatus.disconnected);
    }
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) return;
    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);
    _reconnectTimer = Timer(delay, () {
      if (!state.isConnected) connect();
    });
  }

  Future<void> _disconnect() async {
    try {
      await _channel?.sink.close();
      _channel = null;
    } catch (_) {}
  }

  void _cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  Future<void> reset() async {
    _cancelReconnect();
    await _disconnect();
    state = const ChatWebSocketState();
  }
}

final chatWebSocketControllerProvider =
NotifierProvider<ChatWebSocketController, ChatWebSocketState>(
  ChatWebSocketController.new,
);