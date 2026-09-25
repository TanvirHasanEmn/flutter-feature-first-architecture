import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/custom_widgets/custom_button_small.dart';
import '../../../../core/language/language_controller.dart';
import '../../../../core/utils/app_colors.dart';
import '../../nav/views/nav_bar.dart';

class CancelledCard extends StatelessWidget {
  final String image, title, date, price, cancelled_date, reason;
  final lang = Get.find<LocalizationController>();

  CancelledCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.price,
    required this.cancelled_date,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 109.w,
                height: 109.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r),
                  ),
                  color: Colors.grey[200],
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.image_not_supported, size: 40.sp),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SpinKitCircle(
                       color: AppColor.primaryColor,
                        size: 60,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.fontBlack,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColor.fontBlack,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1.h, color: Color(0xFFEEEEEE)),
          SizedBox(height: 12.h),
          Text(
            cancelled_date,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.fontBlack,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            reason,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.fontBlack,
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.topLeft,
            child: CustomButtonSmall(
              color: Color(0xFF666B75),
              text: lang.tr("cancel_service_button",),
              onPressed: () => Get.to(() => NavBar()),
            ),
          ),
        ],
      ),
    );
  }
}
