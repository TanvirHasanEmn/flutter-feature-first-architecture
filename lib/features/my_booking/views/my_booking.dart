import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/my_booking_controller.dart';
import '../controllers/my_booking_state.dart';
import '../widgets/cards_Active.dart';
import '../widgets/cards_Cancelled.dart';
import '../widgets/cards_Completed.dart';


class MyBookingView extends ConsumerWidget {
  const MyBookingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myBookingControllerProvider);
    final controller = ref.read(myBookingControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  l10n.translate('my_booking_tab'),
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Segmented Tab Headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: BookingTab.values.map((tab) {
                  final isSelected = state.selectedTab == tab;
                  String tabTitle = 'Activo';
                  if (tab == BookingTab.completado) tabTitle = 'Completado';
                  if (tab == BookingTab.cancelado) tabTitle = 'Cancelado';

                  return Expanded(
                    child: InkWell(
                      onTap: () => controller.changeTab(tab),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: Text(
                          tabTitle,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? AppColors.primary : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              Text(
                l10n.translate('my_services_title'),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Bookings List Area
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isLoading && state.currentBookings.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      );
                    }

                    if (state.currentBookings.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.errorMessage ?? 'No hay reservas registradas',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: const Color(0xFF718096),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: controller.refreshBookings,
                              child: const Text('Refrescar'),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: controller.refreshBookings,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: state.currentBookings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final booking = state.currentBookings[index];

                          switch (state.selectedTab) {
                            case BookingTab.activo:
                              return ActiveCard(
                                id: booking.id,
                                image: booking.image,
                                title: booking.title,
                                date: booking.date,
                                price: booking.price,
                              );
                            case BookingTab.completado:
                              return CompletedCard(
                                image: booking.image,
                                title: booking.title,
                                date: booking.date,
                                price: booking.price,
                                serviceId: booking.serviceId,
                              );
                            case BookingTab.cancelado:
                              return CancelledCard(
                                image: booking.image,
                                title: booking.title,
                                date: booking.date,
                                price: booking.price,
                                cancelledDate: "Cancelado el: ${booking.date}",
                                reason: "Servicio cancelado",
                              );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}