// Những cái gì lưu vào local, dùng key - value thì code ở đây

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hit_moments/app/core/constants/storage_constants.dart';

final box = GetStorage('hit_moment');

setToken(String value) {
  box.write(StorageConstants.token, value);
}

String getToken() {
  return box.read(StorageConstants.token) ?? '';
}

setEmail(String value) {
  box.write(StorageConstants.email, value);
}

String getEmail() {
  return box.read(StorageConstants.email) ?? '';
}
setPassWord(String value) {
  box.write(StorageConstants.password, value);
}

String getPassWord() {
  return box.read(StorageConstants.password) ?? '';
}

setLocaleLocal(String languageCode) {
  box.write(StorageConstants.localeLocal, languageCode);
}

Locale getLocaleLocal() {
  return Locale(box.read(StorageConstants.localeLocal) ?? 'vi');
}

setIsFirstTime() {
  box.write(StorageConstants.isFirstTime, false);
}

bool getIsFirstTime() {
  return box.read(StorageConstants.isFirstTime) ?? true;
}

setDarkMode(bool value) {
  box.write(StorageConstants.isDarkMode, value);
}
setUserId(String value) {
  box.write(StorageConstants.userId, value);
}
String getUserId() {
  return box.read(StorageConstants.userId) ?? '';
}
bool getIsDarkMode() {
  return box.read(StorageConstants.isDarkMode) ?? false;
}
