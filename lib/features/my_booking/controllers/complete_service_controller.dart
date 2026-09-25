import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../core/language/language.dart';
import '../../../../core/language/language_controller.dart';
import '../../../../core/network_caller/service/service2.dart';
import '../../../../core/network_caller/utils/utils.dart';

class CompleteServiceController extends GetxController {
  RxString selectedReason = ''.obs;
  TextEditingController otherReasonController = TextEditingController();
  final String bookingId;

  CompleteServiceController({required this.bookingId});

  late LocalizationController lang;
  late List<String> reasons;

  @override
  void onInit() {
    super.onInit();
    lang = Get.find<LocalizationController>();

    reasons = [
      lang.tr("This_services_is_good"),
      lang.tr("Amazing"),
      lang.tr("nice_service"),
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
      final response = await NetworkCalller().patchRequest(
        '${AppUrls.baseUrl5}/booking/update/$bookingId',
        body: {"status": "Complete"},
       // body: {"status": reasonToSend},
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
