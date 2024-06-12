import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as inttl;
import 'package:shefa2ok/Screens/auth/bloc/auth_bloc.dart';
import 'package:shefa2ok/core/shared_widgets/const_text_field_builder.dart';

class BirthDateField extends StatefulWidget {
  const BirthDateField({super.key});

  @override
  State<BirthDateField> createState() => _BirthDateFieldState();
}

class _BirthDateFieldState extends State<BirthDateField> {
  DateTime? birthday;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: Text(
              'تاريخ ميلادك ',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 0.005.sh,
          ),
          GestureDetector(
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1940),
                lastDate: DateTime(2100),
                helpText: 'تاريخ الميلاد',
              );
              setState(() {
                birthday = selectedDate;
              });
            },
            child: ConstTextFieldBuilder(
              label: birthday == null
                  ? 'تاريخ ميلادك'
                  : inttl.DateFormat('dd-MM-yyyy').format(birthday!).toString(),
              validator: (value) {
                if (birthday == null) {
                  return 'اختر تاريخ ميلادك';
                }
                BlocProvider.of<AuthBloc>(context).birthday =
                    inttl.DateFormat('dd-MM-yyyy').format(birthday!).toString();
                return null;
              },
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
