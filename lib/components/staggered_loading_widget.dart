import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:weather_app/themes/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaggeredDotsLoadingWidget extends StatelessWidget {
  const StaggeredDotsLoadingWidget({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 25.sp,
              color: AppColors.whiteColor,
            ),
          ),
          LoadingAnimationWidget.staggeredDotsWave(
            color: AppColors.whiteColor,
            size: 32.sp,
          ),
        ],
      ),
    );
  }
}
