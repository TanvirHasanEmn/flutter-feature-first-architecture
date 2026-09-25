import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/cancel_service_controller.dart';
import '../controllers/my_booking_controller.dart';

class CancelServiceView extends ConsumerStatefulWidget {
  final String bookingId;

  const CancelServiceView({super.key, required this.bookingId});

  @override
  ConsumerState<CancelServiceView> createState() => _CancelServiceViewState();
}

class _CancelServiceViewState extends ConsumerState<CancelServiceView> {
  late final TextEditingController _otherReasonController;

  @override
  void initState() {
    super.initState();
    _otherReasonController = TextEditingController();
  }

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(cancelServiceControllerProvider.notifier)
        .submitCancellation(
      bookingId: widget.bookingId,
      customReason: _otherReasonController.text,
    );

    if (!mounted) return;

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.primary),
      );
    } else {
      // Refresh parent bookings list and pop back
      ref.read(myBookingControllerProvider.notifier).refreshBookings();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Reserva cancelada con éxito'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cancelServiceControllerProvider);
    final controller = ref.read(cancelServiceControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.translate('cancel_service_button'),
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.translate('cancel_service_reason_title'),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: Color(0xFFE2E8F0)),
              Expanded(
                child: ListView(
                  children: [
                    ...state.reasons.map((reason) => RadioListTile<String>(
                      title: Text(
                        reason,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      value: reason,
                      activeColor: AppColors.primary,
                      groupValue: state.selectedReason,
                      onChanged: (val) {
                        if (val != null) controller.selectReason(val);
                      },
                      contentPadding: EdgeInsets.zero,
                    )),
                    RadioListTile<String>(
                      title: Text(
                        'Otros motivos',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      value: 'Others',
                      activeColor: AppColors.primary,
                      groupValue: state.selectedReason,
                      onChanged: (val) {
                        if (val != null) controller.selectReason(val);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (state.selectedReason == 'Others') ...[
                      const SizedBox(height: 8),
                      TextField(
                        controller: _otherReasonController,
                        maxLines: 3,
                        style: GoogleFonts.inter(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: l10n.translate('others_reason_hint'),
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: state.isLoading ? null : _submit,
                        child: state.isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          l10n.translate('send_button_cancel'),
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}