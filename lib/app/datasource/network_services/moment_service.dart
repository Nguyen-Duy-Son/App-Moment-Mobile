import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:http/http.dart' as http;
import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';
import '../../models/react_model.dart';
import '../local/storage.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
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
  Future<dynamic> createMomentImage(String? content, String? weather, XFile? image,String? musicId, String? linkMusic, String? type, {String? videoPath}) async {
    try {
      // Kiểm tra xem tệp có tồn tại hay không
      File? file;
      String? mimeType;
      if (image != null) {
        file = File(image.path);
        if (!await file.exists()) {
          return "File does not exist";
        }

        // Lấy MIME type của tệp
        mimeType = lookupMimeType(file.path);
        if (mimeType == null) {
          return "MIME type could not be determined";
        }
      }

      // Tạo yêu cầu MultipartRequest
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiUrl.createMomentImage),
      );

      // Thêm các trường vào yêu cầu
      request.headers['Authorization'] = 'Bearer ${getToken()}';
      if (content != null){
        request.fields['content'] = content;
      }
      if (weather != null){
        request.fields['weather'] = weather;
      }
      if (musicId != null){
        request.fields['musicId'] = musicId;
      }
      if (linkMusic != null){
        request.fields['linkMusic'] = linkMusic;
      }
      request.fields['type'] = type ?? getStringTypeMoment(TypeMoment.image);
      // Thêm tệp vào yêu cầu
      if(image != null){
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          file?.path ?? '',
          contentType: MediaType.parse(mimeType ?? ''),
          filename: 'anh_moment.jpg', // Tên tệp trên server
        ));
      }
      // Gửi yêu cầu
      var response = await request.send();
      var responseStream = response.stream.transform(utf8.decoder);
      var body = await responseStream.join();

      // Kiểm tra trạng thái phản hồi
      int statusCode = response.statusCode;
      print('Response body: $body');
      return statusCode;
    } catch (e) {
      print("Error while uploading file: $e");
      return e;
    }
  }
  Future<dynamic> createMomentVideo(String? content, String? type, {XFile? video}) async {
    try {
      // Kiểm tra xem tệp có tồn tại hay không
      File? file;
      String? mimeType;

      if (video != null) {
        file = File(video.path);
        if (!await file.exists()) {
          return "File does not exist";
        }
        mimeType = 'video/mp4';  // Mặc định cho video
      }

      // Tạo yêu cầu MultipartRequest
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiUrl.createMomentVideo),
      );

      // Thêm các trường vào yêu cầu
      request.headers['Authorization'] = 'Bearer ${getToken()}';
      if (content != null){
        request.fields['content'] = content;
      }
      request.fields['type'] = type ?? getStringTypeMoment(TypeMoment.image);
      request.files.add(await http.MultipartFile.fromPath(
        'video',
        file?.path ?? '',
        contentType: MediaType.parse(mimeType ?? ''),
        filename: 'video_moment.mp4', // Tên tệp trên server
      ));
      // Gửi yêu cầu
      var response = await request.send();
      var responseStream = response.stream.transform(utf8.decoder);
      var body = await responseStream.join();

      // Kiểm tra trạng thái phản hồi
      int statusCode = response.statusCode;
      print('Response body: $body');
      return statusCode;
    } catch (e) {
      print("Error while uploading file: $e");
      return e;
    }
  }
}