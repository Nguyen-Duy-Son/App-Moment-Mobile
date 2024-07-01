import 'dart:async';
import 'dart:convert';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

enum RequestMethod { GET, POST, PUT, DELETE }

class BaseConnect {
  Future<http.Request> requestInterceptor(http.Request request) async {
    request.headers['Authorization'] = 'Bearer ${getToken()}';
    request.headers['Accept'] = 'application/json, text/plain, */*';
    request.headers['Charset'] = 'utf-8';
    return request;
  }

  Future<dynamic> responseInterceptor(
      http.Request request, http.Response response) async {
    if (response.statusCode < 200 || response.statusCode > 299) {
      handleErrorStatus(response);
      return null;
    }
    return response;
  }

  void handleErrorStatus(http.Response response) {
    switch (response.statusCode) {
      case 400:
      case 404:
      case 500:
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

  Future<dynamic> onRequest(
    String url,
    RequestMethod method, {
    dynamic body,
    Map<String, dynamic>? queryParam,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      print("No internet connection available.");
      return;
    }

    var requestBody = body != null ? jsonEncode(body) : null;
    var uri = Uri.parse(url);
    if (queryParam != null) {
      uri = uri.replace(queryParameters: queryParam);
    }

    var request = http.Request(method.toString().split('.').last, uri);
    request = await requestInterceptor(request);

    http.Response response;
    var headers = {'Content-Type': 'application/json'};
    try {
      switch (method) {
        case RequestMethod.POST:
          response = await http.post(uri, body: requestBody, headers: headers);
          break;
        case RequestMethod.PUT:
          response = await http.put(uri, body: requestBody, headers: headers);
          break;
        case RequestMethod.GET:
          response = await http.get(uri, headers: headers);
          break;
        case RequestMethod.DELETE:
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported request method');
      }
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
