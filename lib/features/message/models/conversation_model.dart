class ConversationPartner {
  final String id;
  final String userName;
  final String profileImage;
  final bool isActive;

  const ConversationPartner({
    required this.id,
    required this.userName,
    required this.profileImage,
    required this.isActive,
  });

  factory ConversationPartner.fromMap(Map<String, dynamic> map) {
    return ConversationPartner(
      id: (map['id'] ?? map['userId'] ?? '').toString(),
      userName: (map['userName'] ?? 'User').toString(),
      profileImage: (map['profileImage'] ?? '').toString(),
      isActive: map['isActive'] == true,
    );
  }
}

class ConversationItem {
  final String roomId;
  final ConversationPartner partner;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;

  const ConversationItem({
    required this.roomId,
    required this.partner,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory ConversationItem.fromMap(Map<String, dynamic> map) {
    return ConversationItem(
      roomId: (map['roomId'] ?? '').toString(),
      partner: map['partner'] is Map<String, dynamic>
          ? ConversationPartner.fromMap(map['partner'] as Map<String, dynamic>)
          : const ConversationPartner(
        id: '',
        userName: 'Unknown',
        profileImage: '',
        isActive: false,
      ),
      lastMessage: (map['lastMessage']?['content'] ?? '').toString(),
      lastMessageTime: (map['lastMessage']?['createdAt'] ?? '').toString(),
      unreadCount: (map['unreadCount'] as num?)?.toInt() ?? 0,
    );
  }
}