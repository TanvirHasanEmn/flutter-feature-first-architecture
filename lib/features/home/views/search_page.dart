// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:monaspro/core/utils/app_colors.dart';
// import '../../../../core/language/language_controller.dart';
// import '../../../../core/utils/image_path.dart';
// import '../controller/search_controller.dart';
// import 'filter_bottomsheet.dart';
//
//
// class SearchPage extends StatelessWidget {
//  // final SearchPageController controller = Get.put(SearchPageController());
//   final lang = Get.find<LocalizationController>();
//
//   SearchPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 16.h),
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () => Get.back(),
//                     icon: Icon(Icons.arrow_back_ios_new, size: 20.sp),
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(lang.tr("search"),
//                         style: GoogleFonts.inter(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 48.w), // placeholder for alignment
//                 ],
//               ),
//               SizedBox(height: 20.h),
//               Obx(() => Center(
//                 child: Container(
//                   height: 52.h,
//                   width: 327.w,
//                   padding:
//                   EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12.r),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.search, color: Colors.grey, size: 20.sp),
//                       SizedBox(width: 8.w),
//                       Expanded(
//                         child: TextField(
//                           onChanged: controller.updateSearch,
//                           controller: TextEditingController()
//                             ..text = controller.searchQuery.value
//                             ..selection = TextSelection.collapsed(
//                                 offset:
//                                 controller.searchQuery.value.length),
//                           style: GoogleFonts.inter(fontSize: 14.sp),
//                           decoration: InputDecoration(
//                             hintText: "Plum",
//                             hintStyle: GoogleFonts.inter(
//                                 color: Colors.grey, fontSize: 14.sp),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                       if (controller.searchQuery.value.isNotEmpty)
//                         GestureDetector(
//                           onTap: controller.clearSearch,
//                           child: Icon(Icons.clear,
//                               color: Colors.grey, size: 18.sp),
//                         ),
//                       SizedBox(width: 10.w),
//                       Image.asset(ImagePath.close, height: 22.h, width: 22.w,),
//                       SizedBox(width: 10.w),
//                       InkWell(
//                         onTap: () => Get.bottomSheet(
//                           FilterBottomSheet(),
//                           isScrollControlled: true,
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//                           ),
//                         ),
//                         child: Image.asset(ImagePath.filter2, height: 24.h, width: 24.w),
//                       ),
//
//                     ],
//                   ),
//                 ),
//               )),
//               SizedBox(height: 24.h),
//               Text(
//                 "Suggestion",
//                 style: GoogleFonts.inter(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                   color: AppColor.fontBlack,
//                 ),
//               ),
//               SizedBox(height: 12.h),
//               Obx(() => Expanded(
//                 child: ListView.builder(
//                   itemCount: controller.suggestions.length,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: EdgeInsets.symmetric(vertical: 8.h),
//                       child: Row(
//                         children: [
//                           Icon(Icons.history,
//                               size: 18.sp, color: Colors.grey),
//                           SizedBox(width: 12.w),
//                           Expanded(
//                             child: Text(
//                               controller.suggestions[index],
//                               style: GoogleFonts.inter(fontSize: 14.sp),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => controller.removeSuggestion(index),
//                             child: Icon(Icons.close,
//                                 size: 18.sp, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
