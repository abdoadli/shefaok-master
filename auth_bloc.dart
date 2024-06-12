import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shefa2ok/core/services/cache_service.dart';
import 'package:shefa2ok/core/consts/const_text.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String gender = 'ذكر';
  late String birthday;
  late String phone;
  File? imageFile;
  bool isLoading = false;
  String imageUrl = '';
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());
      isLoading = true;
      try {
        phone = convertPhoneToEmail(phoneController.text.toString());
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: phone,
          password: passwordController.text.toString(),
        );
        CacheService.setData(
            key: ConstText().currentUID,
            value: FirebaseAuth.instance.currentUser!.uid);
        // print(object)
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .where('uid',
                    isEqualTo: FirebaseAuth.instance.currentUser!
                        .uid) // Specify the field and value to search for
                .get();

        for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
            in querySnapshot.docs) {
          Map<String, dynamic> userData = docSnapshot.data();
          CacheService.setData(key: ConstText().name, value: userData['Name']);
          print(userData);

          // Print or use the userData as required
        }

        CacheService.setData(
            key: ConstText().currentUID,
            value: FirebaseAuth.instance.currentUser!.uid);
        print(FirebaseAuth.instance.currentUser!.uid);
        print(phone);

        emit(LoginSuccess());
        isLoading = false;
      } on FirebaseAuthException catch (e) {
        // print(e);

        if (e.code == 'user-not-found') {
          emit(LoginFailure(errorMsg: 'user-not-found'));
          isLoading = false;
        } else if (e.code == 'wrong-password') {
          emit(LoginFailure(errorMsg: 'wrong-password'));
          isLoading = false;
        }
        isLoading = false;
        emit(LoginFailure(errorMsg: 'Not found'));
      } catch (e) {
        emit(LoginFailure(errorMsg: 'Something went wrong'));
        isLoading = false;
      }
    });
    on<RegisterEvent>((event, emit) async {
      emit(RegisterLoading());
      isLoading = true;
      try {
        phone = convertPhoneToEmail(phoneController.text.toString());

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: phone,
          password: passwordController.text.toString(),
        );
        if (imageFile != null) {
          String imageName = DateTime.now().millisecondsSinceEpoch.toString();

          // Upload image to Firebase Storage
          Reference storageReference =
              FirebaseStorage.instance.ref().child('images/$imageName');
          await storageReference.putFile(imageFile!);

          // Get download URL for the uploaded image
          imageUrl = await storageReference.getDownloadURL();
          print(imageUrl);
        }
        await userInfo(
            phone,
            passwordController.text.toString(),
            nameController.text.toString(),
            phoneController.text.toString(),
            birthday,
            gender,
            imageUrl.toString(), [], []);

        emit(RegisterSuccess('Account created successfully'));
        isLoading = false;
      } on FirebaseAuthException catch (e) {
        print(e);
        if (e.code == 'weak-password') {
          emit(RegisterFailure(errorMsg: 'weak-password'));
          isLoading = false;
        } else if (e.code == 'email-already-in-use') {
          emit(RegisterFailure(errorMsg: 'Account already exist'));
          isLoading = false;
        } else {
          print("errrrrrrrrrrrrroooooooooooorrrrrrrrrr" + e.code);
          isLoading = false;
        }
      } catch (e) {
        emit(RegisterFailure(errorMsg: 'Something went wrong'));
        isLoading = false;
      }
    });
    on<SignOutEvent>((event, emit) async {
      emit(SignOutLoading());
      isLoading = true;
      try {
        signOut;
        passwordController.clear();
        nameController.clear();
        phoneController.clear();

        emit(SignOutSuccess());
        isLoading = false;
      } catch (e) {
        emit(SignOutFailure(errorMsg: 'Something went wrong'));
        isLoading = false;
      }
    });

    on<EditProfileEvent>(
      (event, emit) async {
        emit(EditProfileLoading());
        isLoading = true;
        try {
          // Get the current user
          User? user = FirebaseAuth.instance.currentUser;

          // Update user password
          await user!.updatePassword(passwordController.text.toString());

          String currentUID = CacheService.getData(key: ConstText().currentUID);

          // Query for the document containing the user's UID
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: currentUID)
              .get();

          // Check if the document exists
          if (querySnapshot.docs.isNotEmpty) {
            // Get the document reference
            DocumentReference documentReference =
                querySnapshot.docs.first.reference;

            // Get the current data from the document
            Map<String, dynamic> data =
                querySnapshot.docs.first.data() as Map<String, dynamic>;

            // Update specific fields in the data
            data['Name'] = nameController.text.toString();
            data['birthday'] = birthday.toString();
            data['gender'] = gender.toString();
            data['image'] = imageFile.toString();
            data['Password'] = passwordController.text.toString();
            // Add more fields to update as needed

            // Update the document with the modified data
            await documentReference.update(data);
            CacheService.setData(
                key: ConstText().name, value: nameController.text.toString());

            emit(EditProfileSuccess(msg: 'Profile updated successfully'));
            isLoading = false;
          } else {
            emit(EditProfileFailure(errorMsg: 'Something went wrong'));
            isLoading = false;
          }
        } catch (e) {
          emit(EditProfileFailure(errorMsg: 'Something went wrong'));
          isLoading = false;
        }
      },
    );
  }

  void signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();

      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}

Future<void> userInfo(email, password, name, phone, birthday, gender, image,
    userMedicine, userHistory) async {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await users.add({
      "Name": name,
      "Phone": phone,
      "Email": email,
      "Password": password,
      "birthday": birthday,
      "gender": gender,
      "image": image,
      "userMedicine": userMedicine,
      "userHistory": userHistory,
      "uid": currentUser.uid,
    });
    CacheService.setData(
      key: ConstText().currentUID,
      value: currentUser.uid,
    );
    CacheService.setData(
      key: ConstText().name,
      value: name,
    );
  } else {
    // Handle the case where currentUser is null
    print('Current user is null');
  }
}

String convertPhoneToEmail(String phoneNum) {
  var phone = phoneNum.split('');
  for (int i = 0; i < phone.length; i++) {
    switch (phone[i]) {
      case '0':
        phone[i] = 'A';
        break;
      case '1':
        phone[i] = 'B';
        break;
      case '2':
        phone[i] = 'C';
        break;
      case '3':
        phone[i] = 'D';
        break;
      case '4':
        phone[i] = 'E';
        break;
      case '5':
        phone[i] = 'F';
        break;
      case '6':
        phone[i] = 'G';
        break;
      case '7':
        phone[i] = 'H';
        break;
      case '8':
        phone[i] = 'I';
        break;
      case '9':
        phone[i] = 'J';
        break;
    }
  }
  phone.add('@');
  phone.add('gmail.com');
  return phone.join().toLowerCase();
}
