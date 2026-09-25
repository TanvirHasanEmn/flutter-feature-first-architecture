import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SubscriptionDetailsView extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;

  const SubscriptionDetailsView({
    super.key,
    required this.subscriptionData,
  });

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return DateFormat.yMMMd().add_jm().format(date);
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscription = (subscriptionData['subscription'] as Map<String, dynamic>?) ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Detalles de Suscripción',
          style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _buildRow('Plan', subscription['title']?.toString() ?? 'N/A'),
          _buildRow('Estado', subscription['status']?.toString() ?? 'N/A'),
          _buildRow('Intervalo', subscription['interval']?.toString() ?? 'N/A'),
          _buildRow('Precio', '\$${subscription['price'] ?? 0}'),
          _buildRow('Días restantes de prueba', subscriptionData['remainingDaysForFreePlan']?.toString() ?? '0'),
          _buildRow('Fecha de inicio', _formatDate(subscription['createdAt']?.toString())),
          _buildRow('Última actualización', _formatDate(subscription['updatedAt']?.toString())),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
          Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
}