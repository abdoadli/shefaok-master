import 'package:flutter/material.dart';
import 'package:shefa2ok/My_App/my_theme.dart';

class ButtonBuilder extends StatelessWidget {
  const ButtonBuilder(
      {super.key,
      required this.text,
      required this.ontap,
      this.width,
      this.height,
      this.isLoading = false});

  final String text;
  final VoidCallback ontap;
  final double? width;
  final double? height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ontap,
      child: Center(
        child: isLoading
            ? Container(
                height: height ?? screenHeight * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey,
                ),
                child: const Center(child: CircularProgressIndicator()),
              )
            : Container(
                width: width ?? screenWidth,
                height: height ?? screenHeight * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: MyTheme.primaryColor,
                ),
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
