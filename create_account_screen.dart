import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shefa2ok/Screens/tabs/tab_view.dart';
import 'package:shefa2ok/Screens/auth/bloc/auth_bloc.dart';
import 'package:shefa2ok/Screens/auth/widgets/add_image.dart';
import 'package:shefa2ok/Screens/auth/widgets/birthdate_field.dart';
import 'package:shefa2ok/Screens/auth/widgets/gender_field.dart';
import 'package:shefa2ok/Screens/auth/widgets/name_field.dart';
import 'package:shefa2ok/Screens/auth/widgets/phone_num_field.dart';
import 'package:shefa2ok/Screens/auth/widgets/screen_title.dart';
import 'package:shefa2ok/core/services/cache_service.dart';
import 'package:shefa2ok/core/consts/const_text.dart';
import 'package:shefa2ok/core/shared_widgets/button_builder.dart';

class CreateAccountScreen extends StatefulWidget {
  static const String routeName = "Create Account";

  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  late final AuthBloc bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          CacheService.setData(key: ConstText().authed, value: true);
          isLoading = false;
          setState(() {});
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TabView(),
              ));
          BotToast.showText(text: 'Registered Successfully');
        } else if (state is RegisterFailure) {
          isLoading = false;
          BotToast.showText(
            text: state.errorMsg ?? 'Failed to register',
          );
        }
      },
      builder: (context, state) {
        if (state is RegisterLoading) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),
              body: SingleChildScrollView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                    bottom: 8,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        registerColumn(),
                        ButtonBuilder(
                          text: 'إنشاء حساب',
                          ontap: () {
                            if (formKey.currentState!.validate()) {
                              bloc.add(RegisterEvent());
                            }
                          },
                          isLoading: bloc.isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is RegisterSuccess) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),
              body: SingleChildScrollView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                    bottom: 8,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        registerColumn(),
                        ButtonBuilder(
                          text: 'إنشاء حساب',
                          ontap: () {
                            if (formKey.currentState!.validate()) {
                              bloc.add(RegisterEvent());
                            }
                          },
                          isLoading: bloc.isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (state is RegisterFailure) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),
              body: SingleChildScrollView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                    bottom: 8,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        registerColumn(),
                        ButtonBuilder(
                          text: 'إنشاء حساب',
                          ontap: () {
                            if (formKey.currentState!.validate()) {
                              bloc.add(RegisterEvent());
                            }
                          },
                          isLoading: bloc.isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),
              body: SingleChildScrollView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                    bottom: 8,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        registerColumn(),
                        ButtonBuilder(
                          text: 'إنشاء حساب',
                          ontap: () {
                            if (formKey.currentState!.validate()) {
                              bloc.add(RegisterEvent());
                            }
                          },
                          isLoading: bloc.isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Column registerColumn() {
    return Column(
      children: [
        CreateAccountScreenTitle(),
        const AddImage(),
        SizedBox(
          height: 0.02.sh,
        ),
        NameField(
          controller: bloc.nameController,
        ),
        SizedBox(
          height: 0.02.sh,
        ),
        PhoneNumField(
          controller: bloc.phoneController,
        ),
        SizedBox(
          height: 0.02.sh,
        ),
        const BirthDateField(),
        SizedBox(
          height: 0.02.sh,
        ),
        GenderField(),
        SizedBox(
          height: 0.02.sh,
        ),
        PasswordField(controller: bloc.passwordController),
        SizedBox(
          height: 0.04.sh,
        ),
      ],
    );
  }
}
