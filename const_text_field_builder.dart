import 'package:flutter/material.dart';

class ConstTextFieldBuilder extends StatelessWidget {
  const ConstTextFieldBuilder({
    super.key,
    required this.width,
    this.prefix,
    this.label,
    this.controller,
    this.validator,
    this.textDirection = TextDirection.ltr,
  });
  final String? label;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final double width;
  final TextDirection? textDirection;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection ?? TextDirection.ltr,
      child: SizedBox(
        width: width,
        child: TextFormField(
          // style: AppStyles.customTextStyleGrey,
          readOnly: true,
          enabled: false,
          autofocus: false,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            // errorStyle: AppStyles.customTextStyle7.copyWith(
            //   color: Colors.red[900]!,
            //   fontSize: 10,
            // ),
            // errorBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.red[900]!,
            //   ),
            // ),
            // disabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: AppStyles.primaryB4,
            //   ),
            // ),
            prefixIcon: prefix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            label: Text(
              label ?? 'اختار التاريخ',
              // style: AppStyles.customTextStyle6,
            ),
          ),
        ),
      ),
    );
  }
}
