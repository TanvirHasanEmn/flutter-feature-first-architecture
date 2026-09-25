import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/language/language.dart';
import '../../../../core/language/language_controller.dart';
import '../../../../core/network_caller/service/service2.dart';
import '../../../../core/network_caller/utils/utils.dart';

class CancelServiceController extends GetxController {
  RxString selectedReason = ''.obs;
  TextEditingController otherReasonController = TextEditingController();
  final String bookingId; // 👈 holds the booking ID

  CancelServiceController({required this.bookingId}); // 👈 constructor injection

  late LocalizationController lang;
  late List<String> reasons;

  @override
  void onInit() {
    super.onInit();
    lang = Get.find<LocalizationController>();

    reasons = [
      lang.tr("waiting_for_long_time"),
      lang.tr("unable_to_contact_service_provider"),
      lang.tr("provider_denied_destination"),
      lang.tr("provider_denied_pickup"),
      lang.tr("wrong_address_shown"),
      lang.tr("price_not_reasonable"),
      lang.tr("order_another_service"),
      lang.tr("just_want_to_cancel"),
    ];
  }

  void selectReason(String reason) {
    selectedReason.value = reason;
  }

  void sendCancellation() async {
    final String reasonToSend = selectedReason.value == 'Others'
        ? otherReasonController.text.trim()
        : selectedReason.value;

    if (reasonToSend.isEmpty) {
      Get.snackbar('Error', lang.tr('please_select_or_enter_reason'));
      return;
    }

    debugPrint('Selected reason++++++++++++++++++++++++++++++++++++++++++++++++: $reasonToSend');
    debugPrint('📦 Booking ID passed to controller: $bookingId');

    try {
      final response = await NetworkCalller().postRequest(
        '${AppUrls.baseUrl5}/booking/cancel-booking/$bookingId',
        body: {"cancelReason": reasonToSend},
      );

      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'Booking cancelled successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Cancellation failed',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('❌ Exception during cancellation: $e');
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    otherReasonController.dispose();
    super.onClose();
  }
}
