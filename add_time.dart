import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shefa2ok/Screens/add_time/cubit/for_add_cubit.dart';
import 'package:shefa2ok/Screens/add_time/cubit/for_add_state.dart';
import 'package:shefa2ok/core/shared_widgets/button_builder.dart';
import 'package:shefa2ok/core/shared_widgets/const_text_field_builder.dart';

class AddTimeTap extends StatefulWidget {
  const AddTimeTap({Key? key}) : super(key: key);

  @override
  State<AddTimeTap> createState() => AddTimeTapState();
}

class AddTimeTapState extends State<AddTimeTap> {
  TextEditingController dateController = TextEditingController();
  String? _timeOfDay;
  String? selectedMedicine;
  bool isLoading = false;
  List medicines = [];

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 135, 205, 206),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      setState(() {
        _timeOfDay = value!.format(context).toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.46,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: const Border.fromBorderSide(
                BorderSide(color: Color(0xff87cdce))),
            boxShadow: const [
              BoxShadow(
                color: Color(0xff87cdce),
                spreadRadius: 7,
                blurRadius: 20,
              ),
            ],
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Text(
                'اختر الوقت',
                style: TextStyle(
                  color: const Color(0xff87cdce),
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 4.h,
              ),
              GestureDetector(
                onTap: _showTimePicker,
                child: ConstTextFieldBuilder(
                  label: _timeOfDay ?? 'اختيار الوقت', 
                  textDirection: _timeOfDay == null
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  validator: (value) {
                    if (_timeOfDay == null) {
                      return 'اختر الوقت';
                    }
                    return null;
                  },
                  width: double.infinity,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              SizedBox(
                height: 4.h,
              ),
              BlocConsumer<ForAddCubit, ForAddState>(builder: (context, state) {
                if (state is ForAddSuccess) {
                  return DropdownButtonFormField(
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
                    hint: const Text('اختر العلاج'),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        color: Colors.red[900]!,
                        fontSize: 10,
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    value: selectedMedicine,
                    validator: (value) {
                      if (value == null) {
                        return 'اختر العلاج';
                      }
                      return null;
                    },
                    items: medicines.map(
                      (e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      },
                    ).toList(),
                    onChanged: (model) {
                      selectedMedicine = model as String;
                      print(selectedMedicine);
                      setState(() {});
                    },
                  );
                } else if (state is ForAddLoading) {
                  return DropdownButtonFormField(
                    hint: const Text('اختر العلاج'),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.id.isEmpty) {
                        return 'اختر العلاج';
                      }
                      return null;
                    },
                    items: const [
                      DropdownMenuItem(
                        child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator()),
                      )
                    ],
                    onChanged: (selectedValue) {},
                  );
                } else {
                  return medicines.isEmpty
                      ? DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          hint: const Text('اختر العلاج'),
                          isExpanded: true,
                          validator: (value) {
                            if (value == null) {
                              return 'اختر العلاج';
                            }
                            return null;
                          },
                          items: const [
                            DropdownMenuItem(
                                child: Text('لا يوجد علاجات في الوقت الحالي'))
                          ],
                          onChanged: (selectedValue) {},
                        )
                      : DropdownButtonFormField(
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.3,
                          hint: const Text('اختر العلاج'),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.red[900]!,
                              fontSize: 10,
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          isExpanded: true,
                          value: selectedMedicine,
                          validator: (value) {
                            if (value == null) {
                              return 'اختر العلاج';
                            }
                            return null;
                          },
                          items: medicines.map(
                            (e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            },
                          ).toList(),
                          onChanged: (model) {
                            selectedMedicine = model as String;
                            print(selectedMedicine);
                            setState(() {});
                          },
                        );
                }
              }, listener: (BuildContext context, ForAddState state) {
                if (state is ForAddLoading) {
                } else if (state is ForAddSuccess) {
                  medicines = state.response;
                } else {}
              }),
              const Spacer(),
              BlocListener<ForAddCubit, ForAddState>(
                listener: (context, state) {
                  if (state is AddToUserLoading) {
                    isLoading = true;
                  } else if (state is AddToUserSuccess) {
                    isLoading = false;
                    BotToast.showText(text: state.response);
                  } else if (state is AddToUserFailure) {
                    isLoading = false;
                    BotToast.showText(text: state.errorMessage);
                  } else {
                    isLoading = false;
                    medicines.isEmpty
                        ? BotToast.showText(text: 'Something went wrong')
                        : null;
                  }
                },
                child: ButtonBuilder(
                  text: 'اضافه',
                  isLoading: isLoading,
                  ontap: () {
                    BlocProvider.of<ForAddCubit>(context).addMedicineToUser({
                      'time': _timeOfDay!,
                      'medicine': selectedMedicine,
                    });
                  },
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
