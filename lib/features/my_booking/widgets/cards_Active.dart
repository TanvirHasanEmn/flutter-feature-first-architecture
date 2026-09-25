import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../core/custom_widgets/custom_button_small.dart';
import '../../../../core/custom_widgets/custom_button_small2.dart';
import '../../../../core/language/language_controller.dart';
import '../../../../core/utils/app_colors.dart';
import '../views/cancel_service.dart';
import '../views/complete_service.dart';

class ActiveCard extends StatelessWidget {
  final String? id;
  final String? image;
  final String? title;
  final String? date;
  final String? price;
  final lang = Get.find<LocalizationController>();

  ActiveCard({super.key,
    this.id,
    this.image,
    this.title,
    this.date,
    this.price,
  }) {
    // Debug print to identify null values
    // debugPrint('ActiveCard created with:');
    // debugPrint('Image: $image');
    // debugPrint('Title: $title');
    // debugPrint('Date: $date');
    // debugPrint('Price: $price');
  }

  @override
  Widget build(BuildContext context) {
    // Fallback values
    final safeImage = image ?? 'https://via.placeholder.com/150';
    final safeTitle = title ?? 'Service Title Not Available';
    final safeDate = date ?? 'Date Not Specified';
    final safePrice = price ?? '\$0';

    return Container(
      height: 231.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                      bottomLeft: Radius.circular(12.r)),
                  color: Colors.grey[200],
                ),
                child: Image.network(
                  safeImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.image_not_supported, size: 40.sp),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SpinKitCircle(
                        size: 60,
                        color: AppColor.primaryColor,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      safeTitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.fontBlack,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      safeDate,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColor.fontBlack,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      safePrice,
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
          SizedBox(height: 15.h),
          Divider(height: 1.h, color: Color(0xFFEEEEEE)),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomButtonSmall2(
                  text: lang.tr("cancel_service_button") ?? 'Cancel Service',
                  onPressed: () {
                    if (id != null) {
                      Get.to(() => CancelServicePage(bookingId: id!));
                    } else {
                      debugPrint('❌ Booking ID is null');
                    }
                  },

                ),
              ),


              Align(
                alignment: Alignment.centerRight,
                child: CustomButtonSmall(
                  text: lang.tr("complete_service_button") ?? 'Cancel Service',
                  onPressed: () {
                    if (id != null) {
                      Get.to(() => CompleteServicePage(bookingId: id!));
                    } else {
                      debugPrint('❌ Booking ID is null');
                    }
                  },

                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}