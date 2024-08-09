import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';

class MomentService{
  Future<String> saveImage(String url) async{
    try {
      // Tải ảnh từ URL
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
        // Lấy đường dẫn thư mục tạm thời
        final Directory? tempDir = await getDownloadsDirectory();
        final String tempPath = tempDir!.path;
        // Tạo file mới trong thư mục tạm thời
        final File file = File('$tempPath/image.jpg');
        // Lưu ảnh vào file
        await file.writeAsBytes(bytes);
        return file.path;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Error saving image: $e');
    }
  }
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

  Future<dynamic> getReact(String momentID) async{
    final Map<String, dynamic> params = {
      'postId': momentID
    };
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.reacts,
          RequestMethod.GET,
          queryParam: params
      );
      int statusCode = response['statusCode'];
      if(statusCode == 200){
        return response['data'];
      }
    }catch(e){
      return e;
    }
  }

  Future<dynamic> createReport(String momentID, String description) async{
    final Map<String, dynamic> body = {
      'description': description,
      'postId': momentID
    };
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.createReport,
          RequestMethod.POST,
          body: body
      );
      int statusCode = response['statusCode'];
      return statusCode;
    }catch(e){
      return e;
    }
  }

  Future<dynamic> deleteMoment(String momentID, String description) async{
    final Map<String, dynamic> params = {
      'momentId': momentID
    };
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.getListMoment,
          RequestMethod.DELETE,
          queryParam: params
      );
      int statusCode = response['statusCode'];
      return statusCode;
    }catch(e){
      return e;
    }
  }
  Future<dynamic> createMoment(String content, String weather, File image) async{
    final Map<String, dynamic> body = {
      'image': image,
      'content': content,
      'weather': "Nắng"
    };
    try{
      final response = await BaseConnect.onRequest(
          ApiUrl.getListMoment,
          RequestMethod.POST,
          body: body
      );
      int statusCode = response['statusCode'];
      return statusCode;
    }catch(e){
      return e;
    }
  }
}