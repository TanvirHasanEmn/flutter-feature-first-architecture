import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/payment_method_controller.dart';
import '../models/payment_booking_args.dart';

class PaymentMethodView extends ConsumerWidget {
  final PaymentBookingArgs args;

  const PaymentMethodView({
    super.key,
    required this.args,
  });

  Future<void> _handlePayment(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final error = await ref
        .read(paymentControllerProvider.notifier)
        .processPayment(args);

    if (!context.mounted) return;

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.primary,
        ),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Booking created successfully'),
          backgroundColor: Colors.green,
        ),
      );
      // Reset navigation and send user directly to the home/main tab
      context.go(AppRoutes.mainNav);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentControllerProvider);
    final controller = ref.read(paymentControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Método de pago',
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seleccione método de pago',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Cash on Delivery Card
              // _PaymentOptionTile(
              //   title: 'Efectivo en la entrega',
              //   iconPath: 'assets/icons/cod.png',
              //   isSelected: state.selectedOption == PaymentOption.cod,
              //   onTap: () => controller.selectOption(PaymentOption.cod),
              // ),
              // const SizedBox(height: 12),
              //
              // // Stripe Card
              // _PaymentOptionTile(
              //   title: 'Stripe',
              //   iconPath: 'assets/icons/stripe.png',
              //   isSelected: state.selectedOption == PaymentOption.stripe,
              //   onTap: () => controller.selectOption(PaymentOption.stripe),
              // ),

              const Spacer(),

              // Submit Action Button
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
                  onPressed: state.isLoading ? null : () => _handlePayment(context, ref),
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
                    'Pagar \$${args.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.title,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.account_balance_wallet_outlined,
                size: 28,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              activeColor: AppColors.primary,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }
}