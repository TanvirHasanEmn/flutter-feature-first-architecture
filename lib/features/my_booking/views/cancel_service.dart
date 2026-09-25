import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/language/language_controller.dart';
import '../../../../core/utils/app_colors.dart';
import '../controllers/cancel_service_controller.dart';
import 'cancelled_dialog.dart';
class CancelServicePage extends StatelessWidget {
  final String bookingId;
  final lang = Get.find<LocalizationController>();

  // ✅ Correctly inject the real bookingId into controller
  late final CancelServiceController controller;

  CancelServicePage({super.key, required this.bookingId}) {
    controller = Get.put(CancelServiceController(bookingId: bookingId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppBar(
        backgroundColor: AppColor.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          lang.tr("cancel_service_button"),
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              lang.tr("cancel_service_reason_title"),
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            Divider(color: Colors.grey.shade300, height: 1.h),
            SizedBox(height: 12.h),
            Expanded(
              child: Obx(() => ListView(
                children: [
                  ...controller.reasons.map((reason) => RadioListTile<String>(
                    title: Text(
                      reason,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    value: reason,
                    activeColor: AppColor.primaryColor,
                    groupValue: controller.selectedReason.value,
                    onChanged: (value) => controller.selectReason(value!),
                    contentPadding: EdgeInsets.zero,
                  )),
                  SizedBox(height: 20.h),
                  Text(
                    lang.tr("others_reason_label"),
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: TextField(
                      controller: controller.otherReasonController,
                      maxLines: 3,
                      style: GoogleFonts.inter(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: lang.tr("others_reason_hint"),
                        hintStyle: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        controller.selectedReason.value = 'Others';
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    text: lang.tr("send_button_cancel"),
                    onPressed: () {
                      controller.sendCancellation();
                      cancelledDialog();
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
