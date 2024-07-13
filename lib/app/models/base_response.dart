class BaseResponse{
   int? statusCode;
   String? message;
   dynamic data;

  BaseResponse({required this.statusCode, required this.message, this.data});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    //data = json['data'];
  }
}