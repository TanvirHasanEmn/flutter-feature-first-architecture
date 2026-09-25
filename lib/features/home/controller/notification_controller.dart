import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';

class NotificationState {
  final int selectedTab; // 0: All, 1: Unread
  final List<NotificationItem> notifications;

  const NotificationState({
    this.selectedTab = 0,
    this.notifications = const [
      NotificationItem(
        id: '1',
        title: 'Confirmación de Reserva',
        message: '¡Tu reserva está confirmada! Llegará a tiempo. Toca aquí para ver los detalles',
        dateSection: 'today',
        isRead: true,
      ),
      NotificationItem(
        id: '2',
        title: 'Recordatorio de Servicio',
        message: 'Tu cita para Limpieza de Casa está programada para mañana a las 5:00 PM.',
        dateSection: 'today',
        isRead: true,
      ),
      NotificationItem(
        id: '3',
        title: 'Proveedor de Servicio en Camino',
        message: '¡Tu Servicio está en camino a tu ubicación! Llegada estimada a tiempo.',
        dateSection: 'yesterday',
        isRead: false,
      ),
      NotificationItem(
        id: '4',
        title: 'Pago Recibido',
        message: '¡Gracias! Tu pago de 20 por Limpieza de Casa ha sido procesado con éxito.',
        dateSection: 'yesterday',
        isRead: false,
      ),
    ],
  });

  List<NotificationItem> get filteredNotifications {
    if (selectedTab == 0) return notifications;
    return notifications.where((n) => !n.isRead).toList();
  }

  List<NotificationItem> get todayNotifications =>
      filteredNotifications.where((n) => n.dateSection == 'today').toList();

  List<NotificationItem> get yesterdayNotifications =>
      filteredNotifications.where((n) => n.dateSection == 'yesterday').toList();

  NotificationState copyWith({
    int? selectedTab,
    List<NotificationItem>? notifications,
  }) {
    return NotificationState(
      selectedTab: selectedTab ?? this.selectedTab,
      notifications: notifications ?? this.notifications,
    );
  }
}

class NotificationController extends Notifier<NotificationState> {
  @override
  NotificationState build() => const NotificationState();

  void selectTab(int index) {
    state = state.copyWith(selectedTab: index);
  }
}

final notificationControllerProvider =
NotifierProvider<NotificationController, NotificationState>(
  NotificationController.new,
);