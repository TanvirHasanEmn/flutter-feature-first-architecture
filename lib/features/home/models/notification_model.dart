class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String dateSection; // 'today' | 'yesterday'
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.dateSection,
    this.isRead = false,
  });
}