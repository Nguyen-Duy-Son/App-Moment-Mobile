import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


import 'package:hit_moments/app/core/base/base_connect.dart';
import 'package:hit_moments/app/core/config/api_url.dart';
import 'package:hit_moments/app/models/moment_model.dart';

class ListMomentService{

  Future<dynamic> getListMoment(int pageIndex) async{
    final Map<String, dynamic> queryParam = {
      'page': pageIndex.toString(),
      'limit': '10',
    };
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.getListMoment,
          RequestMethod.GET,
        queryParam: queryParam
      );
      int statusCode = response['statusCode'];
      if(statusCode==200){
        final dataList = response['data']['moments'];
         return (dataList is List ? dataList:[])
             .map((e) => MomentModel.fromJson(e))
             .toList();
      }else{
        return [];
      }
    }catch(e){
      return e.toString();
    }
  }

  Future<dynamic> getListMomentByUserID(String userID, pageIndex) async{
    final Map<String, dynamic> queryParam = {
      'page': pageIndex.toString(),
      'limit': '10',
    };
    try{
      final response = await BaseConnect.onRequest(
          '${ApiUrl.getListMomentByUserID}$userID',
          RequestMethod.GET,
        queryParam: queryParam,
      );
      int statusCode = response['statusCode'];
      if(statusCode==200){
        final dataList = response['data']['moments'];
         return (dataList is List ? dataList:[])
             .map((e) => MomentModel.fromJson(e))
             .toList();
      }else{
        return [];
      }
    }catch(e){
      print("Lỗi $e");
      return e.toString();
    }
  }

  Future<dynamic> getListImagesMoment() async{
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.getListImagesMoment,
          RequestMethod.GET
      );
      int statusCode = response['statusCode'];
      if(statusCode==200){
        return MomentModel.fromJson(response['data']);
      }else{
        return null;
      }
    }catch(e){
      return e.toString();
    }
  }




}