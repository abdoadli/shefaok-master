import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shefa2ok/Screens/search_view/search_screen.dart';
import 'package:shefa2ok/core/shared_widgets/button_builder.dart';

class CheckTab extends StatefulWidget {
  const CheckTab({super.key});

  @override
  State<CheckTab> createState() => _CheckTabState();
}

class _CheckTabState extends State<CheckTab> {
  File? image;
  bool isDone = false;
  //   List<String> suggestions = [];
  // List<String> suggestionsLoc = [];
  List<dynamic> interactions = [];
  List<dynamic> nonInteractions = [];
  Future<void> pickImage(ImageSource source) async {
    var pickedimage = await ImagePicker().pickImage(source: source);
    if (pickedimage != null) {
      image = File(pickedimage.path);

      await _processImage();
    }
  }

  Future<void> _processImage() async {
    final inputImage = InputImage.fromFilePath(image!.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    List<String> extractedText = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        extractedText.add(line.text);
      }
    }

    print(extractedText);

    for (String text in extractedText) {
      if (isDone) {
      } else {
        await _getSuggestions(text);
      }
    }

    print(extractedText);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 0.05.sh),
            Center(
              child: Text(
                'اختر طريقة البحث الخاصة بك',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 0.05.sh),
            ButtonBuilder(
              text: 'كتابة',
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 0.02.sh), // زيادة المسافة بين الأزرار
            ButtonBuilder(
              text: 'مسح',
              ontap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (builder) => Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'اختر من الآتي',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              pickImage(ImageSource.camera);
                                            },
                                            icon: const Icon(
                                              Icons.camera_alt,
                                            )),
                                        const Text('كاميرا')
                                      ],
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              pickImage(ImageSource.gallery);
                                            },
                                            icon: const Icon(
                                              Icons.photo,
                                            )),
                                        const Text('استوديو'),
                                      ],
                                    ),
                                    const Spacer(
                                      flex: 12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getSuggestions(String query) async {
    // Clear previous suggestions
    setState(() {
      isDone = false;
      // suggestions.clear();
    });

    DocumentSnapshot snapshot2 = await FirebaseFirestore.instance
        .collection('medicine')
        .doc(' nonInteractionSearch')
        .get();
    if (snapshot2.exists) {
      var data2 = snapshot2.data() as Map<String, dynamic>;

      if (data2['nonInteractionSearch'] != null) {
        nonInteractions = data2['nonInteractionSearch'];
        for (var nonInteraction in nonInteractions) {
          if (nonInteraction.toLowerCase().contains(query.toLowerCase())) {
            isDone = true;
            return successDialog();
          }
        }
      }
    }
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('medicine')
        .doc('interactionSearch')
        .get();
    var data = snapshot.data() as Map<String, dynamic>;
    if (data['interactionSearch'] != null) {
      interactions = data['interactionSearch'];
      for (var interaction in interactions) {
        if (interaction.toLowerCase().contains(query.toLowerCase())) {
          isDone = true;
          return failedDialog();
        }
      }
    }
  }

  Future successDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            // Make dialog background transparent
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.1), // Slightly visible background
                  ),
                ),
                AlertDialog(
                  surfaceTintColor: Colors.white,
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(
                        top: 20.h, bottom: 18.h, left: 8.w, right: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/done.png",
                          height: 100.r,
                          width: 100.r,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          "!تهنئة",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          "العلاج مناسب",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 15.sp),
                        ),
                        const Spacer(),
                        TextButton(
                          child: Container(
                            height: 35.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: const Color(0xff87cdce),
                            ),
                            child: Center(
                              child: Text(
                                "الرجوع",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future notFoundDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            // Make dialog background transparent
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.1), // Slightly visible background
                  ),
                ),
                AlertDialog(
                  surfaceTintColor: Colors.white,
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(
                        top: 20.h, bottom: 18.h, left: 8.w, right: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/failed.png",
                          height: 100.r,
                          width: 100.r,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          "لم يتم العثور علي العلاج",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          child: Container(
                            height: 35.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: const Color(0xff87cdce),
                            ),
                            child: Center(
                              child: Text(
                                "الرجوع",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future failedDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            // Make dialog background transparent
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black
                        .withOpacity(0.1), // Slightly visible background
                  ),
                ),
                AlertDialog(
                  surfaceTintColor: Colors.white,
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(
                        top: 20.h, bottom: 18.h, left: 8.w, right: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/failed.png",
                          height: 100.r,
                          width: 100.r,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          "! للأسف",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          "العلاج غير مناسب",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 15.sp),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextButton(
                                child: Container(
                                  height: 35.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: const Color(0xff87cdce),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "الرجوع",
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
