// app/views/profile/personalPageview.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/views/profile/informationPersonalWidget.dart';
import 'package:hit_moments/app/views/profile/personalPageWidget.dart';
import 'package:provider/provider.dart';

class PersonalPageScreen extends StatefulWidget {
  const PersonalPageScreen({super.key});

  @override
  State<PersonalPageScreen> createState() => PersonalPageScreenState();

}

class PersonalPageScreenState extends State<PersonalPageScreen>{
  bool valueCheck = false;
  @override
  void initState() {
    super.initState();
  }

  void check() {
    setState(() {
      valueCheck = true;
    });
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
              S.of(context).personal,
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
                    child: Column(
                      children: [
                        Text(context.watch<UserProvider>().user.fullName??"", style: AppTextStyles.of(context).bold20,),
                        const SizedBox(height: 20,),
                        !valueCheck ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: check,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.of(context).neutralColor7,
                                padding: const EdgeInsets.fromLTRB(30, 5, 30, 5)
                              ),
                              child: Text(S.of(context).viewPersonal, style: AppTextStyles.of(context).regular20.copyWith(color: AppColors.of(context).neutralColor11),)
                            ),
                            const PersonalPageWidget(),
                          ],
                        ) : informationPersonalWidget(userInfor: context.watch<UserProvider>().user), 
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      context.watch<UserProvider>().user.avatar!,
                      height: 120.w,
                      width: 130.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}