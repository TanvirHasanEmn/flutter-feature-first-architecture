import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../core/custom_widgets/custom_button_small.dart';
import '../../../../core/custom_widgets/custom_button_small2.dart';
import '../../../../core/language/language_controller.dart';
import '../../../../core/utils/app_colors.dart';
import '../../nav/views/nav_bar.dart';
import '../views/leave_review.dart';

class CompletedCard extends StatelessWidget {
  final String image, title, date, price,serviceId;
  final lang = Get.find<LocalizationController>();
   CompletedCard({super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.price,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
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
                width: 100.w,
                height: 100.h,
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
                        size: 60,
                        color: AppColor.primaryColor,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
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
            ],
          ),
         SizedBox(height: 15.h,),
          Container(height: 1.h, width: double.maxFinite, color: Color(0xFFEEEEEE),),
          SizedBox(height: 15.h,),
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 2 ),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButtonSmall2(
                  text: lang.tr("leave_review_button"),
                  onPressed: () => Get.to(() => LeaveReviewPage(serviceId: serviceId)), // 👈 this now works
                ),


                CustomButtonSmall(
                  text: lang.tr("book_again_button"),
                  onPressed: () => Get.to(() => NavBar()),
                ),
               //SizedBox(width: 165.w,),

              ],
            ),
          ),


        ],
      ),
    );
  }
}
