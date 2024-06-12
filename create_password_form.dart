// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shefa2ok/Screens/auth/view/Create_Account/create_account_screen.dart';

class CreatePasswordForm extends StatefulWidget {
  @override
  _CreatePasswordFormState createState() => _CreatePasswordFormState();
}

class _CreatePasswordFormState extends State<CreatePasswordForm> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController =
  TextEditingController(); // المتحكم لتأكيد كلمة المرور

  void verifyPasswords() {
    // يتحقق مما إذا كانت كلمة المرور وتأكيد كلمة المرور متطابقة
    if (passwordController.text == confirmPasswordController.text) {
      String password = passwordController.text;
      print('Password created: $password');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'كلمتى المرور غير متطابقتان'), // رسالة الخطأ عند عدم تطابق كلمتي المرور
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('تم'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: const Size(390, 844));
    return Padding(
      padding: EdgeInsets.all(20.0.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'انشاء كلمة مرور جديدة',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            'قم بتعيين كلمة مرور قوية للحفاظ على حسابك',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: Colors.grey),
          ),
          SizedBox(height: 30),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'كلمة المرور',
              labelStyle: TextStyle(color: Colors.black54), // Initial color
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFF86CDD0)),
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF86CDD0)),
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
              ),
            ),
          ),
          SizedBox(height: 0.02.sh),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              isDense: true,
              labelText: 'تأكيد كلمة المرور',
              labelStyle: TextStyle(color: Colors.black54), // Initial color
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF86CDD0)),
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF86CDD0)),
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
              ),
            ),
          ),
          SizedBox(height: 0.02.sh),
          Text(
            'رمز واحدة على الأقل',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.normal, color: Colors.red),
          ),
          Text(
            'علي الاقل 8 حرف',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: Colors.green),
          ),
          Text(
            'رقم واحد على الاقل',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
          SizedBox(height: 0.03.sh),
          ElevatedButton(
            onPressed: () {
              // Add verification logic here
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateAccountScreen(),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color(0xFF86CDD0)), // Set the button color here
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(
                  horizontal: 0.01.sh, vertical: 0.02.sw), // Change the values as needed
              child: Text(
                'انشاء حساب',
                style: TextStyle(fontSize: 20.0.sp , color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
