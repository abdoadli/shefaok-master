import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shefa2ok/Screens/auth/bloc/auth_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  File? imageFile;
  Future pickImage(ImageSource source) async {
    var pickedimage = await ImagePicker().pickImage(source: source);
    // late File? image;
    if (pickedimage != null) {
      imageFile = File(pickedimage.path);
      // ignore: use_build_context_synchronously
      BlocProvider.of<AuthBloc>(context).imageFile = imageFile;
      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      IconButton(
          onPressed: () {
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
                                          // BlocProvider.of<AuthBloc>(context)
                                          //     .pickImage(ImageSource.camera);
                                        },
                                        icon: const Icon(
                                          Icons.camera_alt,
                                        )),
                                    const Text('الكاميرا')
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
                                          // BlocProvider.of<AuthBloc>(context)
                                          //     .pickImage(ImageSource.gallery);
                                        },
                                        icon: const Icon(
                                          Icons.photo,
                                        )),
                                    const Text('الإستوديو'),
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
          icon: imageFile == null
              ? Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                      )),
                  child: Icon(
                    Icons.add_a_photo,
                    size: 40.sp,
                  ))
              : Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      image: DecorationImage(image: FileImage(imageFile!))),
                )),
      SizedBox(
        height: 0.01.sh,
      ),
      const Text('اضافه صورة'),
      SizedBox(
        height: 0.01.sh,
      ),
      const Text(
        'ستكون هذه صورتك في التطبيق',
        style: TextStyle(color: Colors.grey),
      ),
    ]);
  }
}
