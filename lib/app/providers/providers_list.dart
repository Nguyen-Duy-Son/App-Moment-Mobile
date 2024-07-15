import 'package:hit_moments/app/providers/auth_provider.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:hit_moments/app/providers/theme_provider.dart';
import 'package:hit_moments/app/providers/user_provider.dart';

import 'language_provider.dart';

final listProviders = [
  MomentProvider(),
  ThemeProvider(),
  UserProvider(),
  LocaleProvider(),
  AuthProvider()
];
