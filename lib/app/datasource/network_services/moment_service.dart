import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';
import '../../models/react_model.dart';
import '../local/storage.dart';

class MomentService{

  Future<dynamic> sendReact(String momentId) async{
    final Map<String, dynamic> body = {
      'momentId' : momentId,
      'react': '❤'
    };
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.reacts,
          RequestMethod.POST,
          body: body
      );
      int statusCode = response['statusCode'];
      if(statusCode == 201){
        return response['message'];
      }
    }catch(e){
      return e;
    }
  }

  Future<List<ReactModel>> getReact(String momentID) async {
    final Map<String, dynamic> params = {
      'postId': momentID
    };

    try {
      final response = await BaseConnect.onRequest(
        '${ApiUrl.reacts}/$momentID',
        RequestMethod.GET,
        queryParam: params,
      );
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        List<dynamic> data = response['data']['reactions'];
        List<ReactModel> reactList = data.map((json) => ReactModel.fromJson(json)).toList();
        return reactList;
      } else {
        return [];
      }
    } catch (e) {
      print("Lỗi $e");
      return [];
    }
  }

  Future<dynamic> createReport(String momentID, String description) async{
    final Map<String, dynamic> body = {
      'description': description,
      'momentId': momentID
    };
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.createReport,
          RequestMethod.POST,
          body: body
      );
      int statusCode = response['statusCode'];
      print("Báo cáo $response");
      return statusCode;
    }catch(e){
      print("Lỗi $e");

      return e;
    }
  }

  Future<dynamic> deleteMoment(String momentID) async{
    final Map<String, dynamic> params = {
      'momentId': momentID
    };
    try{
      final response = await BaseConnect.onRequest(
          '${ApiUrl.getListMoment}$momentID',
          RequestMethod.DELETE,
          queryParam: params
      );
      int statusCode = response['statusCode'];
      print('Xoá $response');

      return statusCode;
    }catch(e){
      print('Lỗi ${e}');
      return e;
    }
  }
  Future<String> convertFileToBase64(File file) async {
    List<int> bytes = await file.readAsBytes();
    String base64String = base64Encode(bytes);
    return base64String;
  }
  Future<dynamic> createMoment(String content, String weather, File image) async{
    String base64Image = await convertFileToBase64(image);

    final Map<String, dynamic> body = {
      'image': base64Image,
      'content': content,
      'weather': weather
    };
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.getListMoment,
          RequestMethod.POST,
          body: body
      );
      int statusCode = response['statusCode'];
      print("két quả là ${response}");
      return statusCode;
    }catch(e){
      print("lỗi $e");

      return e;
    }
  }
}