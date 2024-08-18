import 'dart:io';

// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class editInformationPersonal extends StatefulWidget {
  // final User userInfor;

  const editInformationPersonal({super.key});

  @override
  State<editInformationPersonal> createState() =>
      editInformationPersonalState();
}

class editInformationPersonalState extends State<editInformationPersonal> {
  bool isEditing = false; // Add this line
  late User userInfor;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  String? _imageFile;

  // @override
  // void initState() {
  //   super.initState();
  //   userInfor = context.watch<UserProvider>().user;
  //   imageController.text = userInfor.avatar!;
  //   fullNameController.text = userInfor.fullName;
  //   phoneNumberController.text = userInfor.phoneNumber ?? '';
  //   dobController.text = formatDate(userInfor.dob!) ?? '';
  //   emailController.text = userInfor.email! ?? '';
  // }
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().getMe();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userInfor = context.watch<UserProvider>().user;
    imageController.text = userInfor.avatar!;
    fullNameController.text = userInfor.fullName;
    phoneNumberController.text = userInfor.phoneNumber ?? '';
    dobController.text = formatDate(userInfor.dob!) ?? '';
    emailController.text = userInfor.email! ?? '';
  }

  Future<void> _pickImage() async {
    final action = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an action'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text(
                    'Take a Picture',
                    style: TextStyle(color: Colors.blue, fontSize: 20.sp),
                  ),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.w)),
                GestureDetector(
                  child: Text(
                    'Select from Gallery',
                    style: TextStyle(color: Colors.blue, fontSize: 20.sp),
                  ),
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    ); // Mở thư viện ảnh
                    if (pickedFile != null) {
                      setState(() {
                        imageController.text = pickedFile.path;
                        _imageFile = pickedFile.path;
                      });

                      // imageController.text =
                      //     path.basename(imageController.text);

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatPhone(String phone) {
    final String firstPart = phone.substring(0, 4);
    final String remaining = phone.substring(4);
    final tmp =
        remaining.replaceRange(0, remaining.length, 'X' * remaining.length);
    final String formattedRemaining =
        tmp.replaceAllMapped(RegExp(r".{3}"), (match) {
      return '${match.group(0)} ';
    });

    final String formatted = '$firstPart $formattedRemaining';

    return formatted.trim(); // Use trim to remove the trailing space
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 15.w),
            child: Text(
              overflow: TextOverflow.ellipsis,
              S.of(context).personalInformation,
              style: AppTextStyles.of(context).bold32,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 60.h),
                    padding: EdgeInsets.only(top: 80.h),
                    height: 500.h,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primaryColor2,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.of(context).neutralColor8,
                          offset: const Offset(0, -2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 12.w),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Information(
                              iconUrl: Assets.icons.userProfile,
                              title: userInfor.fullName,
                              isEditing: isEditing,
                              controller: fullNameController,
                            ),
                            Information(
                              iconUrl: Assets.icons.phoneLight,
                              title: userInfor.phoneNumber!,
                              isEditing: isEditing,
                              controller: phoneNumberController,
                            ),git
                            Information(
                              iconUrl: Assets.icons.calendarOutline,
                              title: formatDate(userInfor.dob!),
                              isEditing: isEditing,
                              controller: dobController,
                            ),
                            Information(
                              iconUrl: Assets.icons.mail2,
                              title: userInfor.email!,
                              isEditing: isEditing,
                              controller: emailController,
                            ),
                            SizedBox(
                              height: 20.w,
                            ),
                            GestureDetector(
                              onTap: () async{
                                if (isEditing) {
                                  await Provider.of<UserProvider>(context,
                                          listen: false)
                                      .updateUser(
                                    fullNameController.text,
                                    emailController.text,
                                    phoneNumberController.text,
                                    dobController.text,
                                    _imageFile != null
                                        ? File(_imageFile!)
                                        : null,
                                  );
                                  print(Provider.of<UserProvider>(context,
                                      listen: false)
                                      .isLoadingProfile);
                                  if (Provider.of<UserProvider>(context,
                                              listen: false)
                                          .isLoadingProfile ==
                                      false) {
                                    // print("alo");
                                    setState(() {
                                      isEditing = !isEditing;
                                    });
                                    context.read<UserProvider>().getMe();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Loading...'),
                                      ),
                                    );
                                  }
                                } else {
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                }
                              },
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.of(context).neutralColor7,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 8.w),
                                  child: Text(
                                    isEditing
                                        ? S.of(context).complete
                                        : S.of(context).editProfile,
                                    style: AppTextStyles.of(context)
                                        .regular20
                                        .copyWith(
                                            color: AppColors.of(context)
                                                .neutralColor11),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _imageFile != null
                            ? Image.file(
                                File(_imageFile!),
                                height: 120.w,
                                width: 120.h,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                userInfor.avatar!,
                                height: 120.w,
                                width: 120.h,
                                fit: BoxFit.fill,
                              ),
                      ),
                      isEditing == true
                          ? Positioned(
                              right: 10,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _pickImage();
                                },
                                child: SvgPicture.asset(
                                  Assets.icons.add,
                                  width: 30.w,
                                  height: 30.w,
                                  // color: AppColors.of(context).primaryColor10,
                                  // color: Colors.lightBlueAccent,
                                ),
                              ))
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Information extends StatelessWidget {
  const Information({
    super.key,
    required this.iconUrl,
    required this.title,
    required this.isEditing,
    this.controller,
  });

  final String iconUrl;
  final String title;
  final bool isEditing;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconUrl,
            width: 20.w,
            height: 20.w,
            color: AppColors.of(context).primaryColor10,
          ),
          SizedBox(
            width: 16.w,
          ),
          SizedBox(
            width: 160.w,
            child: isEditing
                ? TextFormField(
                    controller: controller,
                    style: AppTextStyles.of(context).light20,
                  )
                : Text(
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    title,
                    style: AppTextStyles.of(context).light20,
                  ),
          ),
        ],
      ),
    );
  }
}
