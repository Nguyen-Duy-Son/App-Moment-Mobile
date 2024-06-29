import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:http/http.dart'
    as http; // Add this line to import the http package

import 'package:connectivity_plus/connectivity_plus.dart';

enum RequestMethod { GET, POST, PUT, DELETE }

class BaseModel {
  BaseModel();

  BaseModel.fromJson(Map<String, dynamic> json);

  toJson() {}
}

class BaseConnect {
  int get requestAgainSecond =>
      10; // if request failed, it will try again after 10 seconds
  int get timeOutSecond => 60; // request time out
  bool isShowLoading = true; // show loading when request
  String? get baseUrl => null; // base url
  Duration get timeout => Duration(seconds: timeOutSecond);
  Future<http.Request> requestInterceptor(http.Request request) async {
    request.headers['Authorization'] = 'Bearer ${getToken()}';
    request.headers['Accept'] = 'application/json, text/plain, */*';
    request.headers['Charset'] = 'utf-8';
    return request;
  }

  Future<dynamic> responseInterceptor(
      http.Request request, http.Response response) async {
    // Check if the status code indicates an error
    if (response.statusCode < 200 || response.statusCode > 299) {
      handleErrorStatus(response);
      // Optionally, return null or a custom error response here
      return null;
    }

    // If the status code indicates success, return the response as is
    return response;
  }

  void handleErrorStatus(http.Response response) {
    switch (response.statusCode) {
      case 400:
      case 404:
      case 500:
        //
        final Map<String, dynamic> errorMessage =
            jsonDecode(response.body.toString());
        String message = '';
        if (errorMessage.containsKey('error') ||
            errorMessage.containsKey('message')) {
          if (errorMessage['error'] is Map) {
            message = errorMessage['error']['message'];
          } else {
            message =
                (errorMessage['message'] ?? errorMessage['error']).toString();
          }
        } else {
          errorMessage.forEach((key, value) {
            if (value is List) {
              message += '${value.join('\n')}\n';
            } else {
              message += value.toString();
            }
          });
        }
        print(message);
        break;
      case 401:
        String message =
            'CODE (${response.statusCode}):\n${response.reasonPhrase}';
        print(message);
        //Remove token
        setToken('');
        break;
      default:
        break;
    }
  }

  ////////////////////////////////////////////////////////////////
  /// [body] gửi request cho các phương thức POST, PUT, PATCH
  ///
  /// [queryParam] gửi request dạng queryParam cho các phương thức GET
  ///
  /// [baseModel] dùng để parse dữ liệu mong muốn trả về
  Future<dynamic> onRequest<T>(
    String url,
    RequestMethod method, {
    dynamic body,
    T Function(Map<String, dynamic>)?
        fromJson, // Model deserialization function
    Map<String, dynamic>? queryParam,
    Function(dynamic data)? convertResponse,
    bool? isShowLoading,
  }) async {
    // Check network connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      // TODO: Show network connectivity error message
      return;
    }

    // Prepare the request body
    if (body != null) {
      if (body is List) {
        body = body.map((e) => e.toJson()).toList();
      } else if (body is BaseModel) {
        body = body.toJson();
      }
    }

    // Log the request
    printRequestLog(url, method, body);

    try {
      // Execute the HTTP request
      final http.Response response =
          await executeHttpRequest(url, method, body, queryParam)
              .timeout(Duration(seconds: 30));

      // Log the response
      printResponseLog(url, method, response);

      // Process the response
      final dynamic responseData = convertResponse != null
          ? convertResponse(jsonDecode(response.body))
          : jsonDecode(response.body);
      if (fromJson != null && responseData is Map<String, dynamic>) {
        return fromJson(responseData);
      }
      return responseData;
    } on TimeoutException catch (_) {
      // Handle timeout
      // TODO: Show timeout error message
    } catch (e) {
      // Handle other errors
      // TODO: Implement retry logic or show error message
    }
    return null;
  }

  void printRequestLog(String url, RequestMethod method, dynamic body) {
    // Implement logging for the request
  }

  void printResponseLog(
      String url, RequestMethod method, http.Response response) {
    // Implement logging for the response
  }

  Future<http.Response> executeHttpRequest(String url, RequestMethod method,
      dynamic body, Map<String, dynamic>? queryParam) async {
    // Build the full URL
    var uri = Uri.parse(url);
    if (queryParam != null) {
      uri = uri.replace(queryParameters: queryParam);
    }

    // Set up headers
    var headers = {'Content-Type': 'application/json'};

    // Execute the HTTP request
    switch (method) {
      case RequestMethod.GET:
        return await http.get(uri, headers: headers);
      case RequestMethod.POST:
        return await http.post(uri, headers: headers, body: jsonEncode(body));
      case RequestMethod.PUT:
        return await http.put(uri, headers: headers, body: jsonEncode(body));
      case RequestMethod.DELETE:
        return await http.delete(uri, headers: headers);
      default:
        throw UnimplementedError('The HTTP method is not implemented');
    }
  }
}
