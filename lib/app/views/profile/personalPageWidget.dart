// app/views/profile/personalPageWidget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/config/theme_config.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hit_moments/app/providers/language_provider.dart';
import 'package:hit_moments/app/providers/theme_provider.dart';
import 'package:hit_moments/app/views/auth/login/login_view.dart';
import 'package:provider/provider.dart';

import '../../datasource/local/storage.dart';
import '../../routes/app_routes.dart';
import '../auth/auth_view.dart';

class PersonalPageWidget extends StatefulWidget {
  const PersonalPageWidget({super.key});

  @override
  State<PersonalPageWidget> createState() => PersonalPageScreenState();
}

class PersonalPageScreenState extends State<PersonalPageWidget> {
  bool _value1 = getIsDarkMode();
  bool _value2 = getLocaleLocal().languageCode == 'en' ? true : false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Assets.icons.lightDark,
                      color: AppColors.of(context).neutralColor11,
                    ),
                    SizedBox(width: 10.w,),
                    Text(
                        AppLocalizations.of(context)!.modeLightDark,
                        style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12)
                    ),
                  ],
                ),
                Switch(
                  value : _value1,
                  onChanged: (value) {
                    setState(() {
                      if (_value1!=true) {
                        context.read<ThemeProvider>().setThemeData(ThemeConfig.darkTheme);
                      } else {
                        context.read<ThemeProvider>().setThemeData(ThemeConfig.lightTheme);
                      }
                      _value1 = value;
                      setDarkMode(_value1);
                    });
                  },
                ),
              ],
            ),
            Container(
              margin:  EdgeInsets.symmetric(vertical: 6.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Assets.icons.settings,color: AppColors.of(context).neutralColor11,),
                    SizedBox(width: 15.w,),
                    Text(
                        AppLocalizations.of(context)!.language,
                        style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12)
                    ),
                  ],
                ),
                Switch(
                  value : _value2,
                  onChanged: (value) {
                    setState(() {
                      if (value==true) {
                        context.read<LocaleProvider>().changeLocale(const Locale('en'));
                      } else {
                        context.read<LocaleProvider>().changeLocale(const Locale('vi'));
                      }
                      _value2 = value;
                      setLocaleLocal(_value2 ? 'en' : 'vi');
                    });
                  },
                ),
              ],
            ),
            Container(
              margin:  EdgeInsets.only(top: 6.w, bottom: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(Assets.icons.danger,color: AppColors.of(context).neutralColor11,),
                SizedBox(width: 15.w,),
                Text(AppLocalizations.of(context)!.report, style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin:  EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(Assets.icons.document2,color: AppColors.of(context).neutralColor11,),
                SizedBox(width: 15.w,),
                Text(AppLocalizations.of(context)!.blockList, style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin:  EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(Assets.icons.star,color: AppColors.of(context).neutralColor11,),
                SizedBox(width: 15.w,),
                Text(AppLocalizations.of(context)!.review, style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin:  EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(Assets.icons.document2,color: AppColors.of(context).neutralColor11,),
                SizedBox(width: 15.w,),
                Text(AppLocalizations.of(context)!.tos, style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin:  EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(Assets.icons.shield,color: AppColors.of(context).neutralColor11,),
                SizedBox(width: 15.w,),
                Text(AppLocalizations.of(context)!.privacy, style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12))
              ],
            ),
            Container(
              margin:  EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            InkWell(
              onTap: () {
                setEmail('');
                setPassWord('');
                setToken('');
                setUserID('');
                setAvatarUser('');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthView(),
                    ),
                    ModalRoute.withName(AppRoutes.AUTHENTICATION));
              },
              child: Row(
                children: [
                  SvgPicture.asset(Assets.icons.logout,color: AppColors.of(context).neutralColor11,),
                  SizedBox(width: 15.w,),
                  Text(AppLocalizations.of(context)!.logout, style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).neutralColor12))
                ],
              ),
            ),
            Container(
              margin:  EdgeInsets.symmetric(vertical: 12.w),
              child: Divider(
                color: AppColors.of(context).neutralColor12,
                height: 1,
              ),
            ),
            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  SvgPicture.asset(Assets.icons.trash,color: AppColors.of(context).neutralColor11,),
                  SizedBox(width: 15.w,),
                  Text(AppLocalizations.of(context)!.deleteAcc, style: AppTextStyles.of(context).light20.copyWith(color: AppColors.of(context).primaryColor10))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}