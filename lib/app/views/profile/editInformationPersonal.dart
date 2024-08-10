// app/views/profile/editInformationPersonal.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class editInformationPersonal extends StatefulWidget {
  final User userInfor;
  const editInformationPersonal({super.key, required this.userInfor});
  
  @override
  State<editInformationPersonal> createState() => editInformationPersonalState();
} 

class editInformationPersonalState extends State<editInformationPersonal> {
  @override
  void initState() {
    super.initState();
  }

  String formatPhone(String phone) {
    final String firstPart = phone.substring(0, 4);
    final String remaining = phone.substring(4);
    final tmp = remaining.replaceRange(0, remaining.length, 'X' * remaining.length);
    final String formattedRemaining = tmp.replaceAllMapped(RegExp(r".{3}"), (match) {
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
                        Text(context.watch<UserProvider>().user.fullName, style: AppTextStyles.of(context).bold20,),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: (context.watch<UserProvider>().isLoandingProfiles) ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(Assets.icons.call),
                                      TextFormField(
                                        decoration: InputDecoration.collapsed(
                                          hintText: formatPhone(widget.userInfor.phoneNumber!), 
                                          hintStyle: AppTextStyles.of(context).light20
                                        ),
                                        style: AppTextStyles.of(context).light20,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(Assets.icons.calendar),
                                      Container(
                                        margin: EdgeInsets.only(left: 20.w),
                                        width: 150.w,
                                        child: Text(formatDate(widget.userInfor.dob!), style: AppTextStyles.of(context).light20,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(Assets.icons.mail),
                                      Container(
                                        margin: EdgeInsets.only(left: 20.w),
                                        width: 150.w,
                                        child: Text(widget.userInfor.email!, style: AppTextStyles.of(context).light20,)
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 70.h,),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.of(context).neutralColor7,
                                      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5)
                                    ),
                                    child: Text(S.of(context).editInfor, style: AppTextStyles.of(context).regular20.copyWith(color: AppColors.of(context).neutralColor11),)
                                  ),
                                  const SizedBox(height: 40,),
                                ],
                              ) : const SizedBox(),
                            ),
                          ),
                        ) 
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