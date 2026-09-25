import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class BookingModel {
  final String id;
  final String title;
  final String image;
  final String date;
  final String price;
  final String serviceId;

  BookingModel({
    required this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.price,
    required this.serviceId,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    try {
      final service = json['service'] as Map<String, dynamic>? ?? {};

      // Safely parse date
      String formattedDate = 'Date not available';
      if (json['date'] != null) {
        try {
          final parsedDate = DateTime.tryParse(json['date']) ?? DateTime.now();
          formattedDate = DateFormat('MMM d, y').format(parsedDate);
        } catch (e) {
          debugPrint('❌ Date format error: $e');
        }
      }

      return BookingModel(
        id: json['id']?.toString() ?? 'unknown_id',
        title: service['title']?.toString() ?? 'Unknown Service',
        image: service['image']?.toString() ?? '',
        date: formattedDate,
        price: '\$${service['price']?.toString() ?? '0'}',
        serviceId: service['id']?.toString() ?? '',
      );
    } catch (e) {
      debugPrint('❌ Booking parsing error: $e');
      return BookingModel(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Error loading service',
        image: '',
        date: 'Error',
        price: '\$0',
        serviceId: 'error_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }

}
