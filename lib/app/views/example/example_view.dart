// app/views/example/example_view.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hit_moments/app/core/config/theme_config.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
//import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/providers/language_provider.dart';
import 'package:hit_moments/app/providers/theme_provider.dart';
import 'package:hit_moments/app/views/moment/camera/take_pictures_screen.dart';
import 'package:provider/provider.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    print(Platform.localeName);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.of(context).primaryColor12,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.hello,
              style: AppTextStyles.of(context).regular32.copyWith(
                color: AppColors.of(context).neutralColor12,
              ),
            ),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(),) );
            },
                child: Text("Chuyển màn"))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Switch(
          onChanged: (value) {
            setState(() {
              _value = value;
              print(value);
              if (value) {
                context.read<LocaleProvider>().changeLocale(const Locale('en'));
                context.read<ThemeProvider>().setThemeData(ThemeConfig.darkTheme);
              } else {
                context.read<LocaleProvider>().changeLocale(const Locale('vi'));
                context.read<ThemeProvider>().setThemeData(ThemeConfig.lightTheme);
              }
            });
          },
          value: _value,
        ),
      ),
    );
  }
}
