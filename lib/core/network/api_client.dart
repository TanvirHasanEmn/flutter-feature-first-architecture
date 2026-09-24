import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import '../utils/app_logger.dart';

class ResponseData {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String errorMessage;

  ResponseData({
    required this.isSuccess,
    required this.statusCode,
    required this.responseData,
    this.errorMessage = '',
  });
}

class NetworkCaller {
  final int timeoutDuration = 80;

  Future<ResponseData> getRequest(String url, {String? token}) async {
    AppLoggerHelper.info('GET Request: $url');
    try {
      final Response response = await get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': token ?? '',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      log(response.headers.toString());
      log(response.statusCode.toString());
      log(response.body);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> postRequest(
      String url, {
        Map<String, dynamic>? body,
        String? token,
      }) async {
    AppLoggerHelper.info('POST Request: $url');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body)}');

    try {
      final Response response = await post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> putRequest(
      String url, {
        Map<String, dynamic>? body,
        String? token,
      }) async {
    AppLoggerHelper.info('PUT Request: $url');
    AppLoggerHelper.info('Request Body: ${jsonEncode(body)}');

    try {
      final Response response = await put(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> deleteRequest(String url, {String? token}) async {
    AppLoggerHelper.info('DELETE Request: $url');
    try {
      final Response response = await delete(
        Uri.parse(url),
        headers: {
          'Authorization': token ?? '',
          'Content-type': 'application/json',
        },
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseData> patchRequest(
      String url, {
        Map<String, dynamic>? body,
        String? token,
      }) async {
    AppLoggerHelper.info('Patch Request: $url');
    AppLoggerHelper.info('Patch body: $body');

    try {
      final Response response = await patch(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': token ?? '',
        },
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> putFormDataWithImage(
      String res,
      String url,
      Map<String, dynamic> body,
      File imageFile, {
        String mainKey = '',
        String? token = '',
        String imageName = 'profileImage',
      }) async {
    log('Request token: $token');
    log('Request Body: ${jsonEncode(body)}');

    try {
      var request = http.MultipartRequest(res, Uri.parse(url));
      request.headers.addAll({'Authorization': token ?? ''});

      String filePath = imageFile.path;
      String? mimeType = lookupMimeType(filePath);

      if (mimeType == null) {
        log('Could not determine MIME type for the file');
        return {'success': false, 'message': 'Invalid file type'};
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          imageName,
          filePath,
          contentType: MediaType.parse(mimeType),
        ),
      );
      request.fields[mainKey] = jsonEncode(body);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Success',
          'data': jsonDecode(response.body),
        };
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
      return {'success': false, 'message': 'Exception: $e'};
    }
  }

  Future<Map<String, dynamic>> putImage(
      String res,
      String url,
      Map<String, dynamic> body,
      File imageFile, {
        String? token = '',
        String imageName = 'profileImage',
      }) async {
    log('Request token: $token');
    log('Request Body: ${jsonEncode(body)}');

    try {
      var request = http.MultipartRequest(res, Uri.parse(url));
      request.headers.addAll({'Authorization': token ?? ''});

      String filePath = imageFile.path;
      String? mimeType = lookupMimeType(filePath);

      if (mimeType == null) {
        log('Could not determine MIME type for the file');
        return {'success': false, 'message': 'Invalid file type'};
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          imageName,
          filePath,
          contentType: MediaType.parse(mimeType),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Success',
          'data': jsonDecode(response.body),
        };
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
      return {'success': false, 'message': 'Exception: $e'};
    }
  }

  Future<Map<String, dynamic>> patchDocuments(
      String res,
      String url,
      Map<String, dynamic> body,
      File imageFontFile,
      File imageBackFile, {
        String? token = '',
        String idCardFront = 'IDCardFont',
        String idCardBack = 'IDCardBack',
      }) async {
    log('Request token: $token');
    log('Request Body: ${jsonEncode(body)}');

    try {
      var request = http.MultipartRequest(res, Uri.parse(url));
      request.headers.addAll({'Authorization': token ?? ''});

      String fontFilePath = imageFontFile.path;
      String? mimeType = lookupMimeType(fontFilePath);

      String backFilePath = imageBackFile.path;
      String? mimeType2 = lookupMimeType(backFilePath);

      if (mimeType == null) {
        return {'success': false, 'message': 'Invalid Front file type'};
      }
      if (mimeType2 == null) {
        return {'success': false, 'message': 'Invalid Back file type'};
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          idCardFront,
          fontFilePath,
          contentType: MediaType.parse(mimeType),
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          idCardBack,
          backFilePath,
          contentType: MediaType.parse(mimeType2),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log('Response Status Code: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Success',
          'data': jsonDecode(response.body),
        };
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      debugPrint('An error occurred: $e');
      return {'success': false, 'message': 'Exception: $e'};
    }
  }

  Future<String> sendFormDataWithImage(
      String url,
      dynamic body,
      List<File> imageFiles, {
        String? token,
      }) async {
    try {
      AppLoggerHelper.info('Patch Request: $url');
      AppLoggerHelper.info('Patch body: $body');
      AppLoggerHelper.info('Patch body images: ${imageFiles.length}');

      var request = MultipartRequest('PATCH', Uri.parse(url));
      request.fields['textData'] = jsonEncode(body);

      if (imageFiles.isNotEmpty) {
        final mimeType = lookupMimeType(imageFiles[0].path);
        var fontFile = await MultipartFile.fromPath(
          'IDCardFont',
          imageFiles[0].path,
          filename: path.basename(imageFiles[0].path),
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );
        request.files.add(fontFile);
      }
      if (imageFiles.length > 1) {
        final mimeType = lookupMimeType(imageFiles[1].path);
        var backFile = await MultipartFile.fromPath(
          'IDCardBack',
          imageFiles[1].path,
          filename: path.basename(imageFiles[1].path),
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );
        request.files.add(backFile);
      }

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = token;
      }

      var response = await request.send();
      var data = await Response.fromStream(response);
      AppLoggerHelper.info('Patch response: ${data.body}');

      if (response.statusCode == 307) {
        return jsonDecode(data.body)['message'] ?? '';
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 'Success';
      } else {
        return jsonDecode(data.body).toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  ResponseData _handleResponse(Response response) {
    AppLoggerHelper.info('Response Status: ${response.statusCode}');
    AppLoggerHelper.info('Response Body: ${response.body}');

    dynamic decodedResponse;
    try {
      decodedResponse = jsonDecode(response.body);
    } catch (_) {
      decodedResponse = response.body;
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decodedResponse is Map && decodedResponse['success'] == true) {
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedResponse['data'],
        );
      } else {
        return ResponseData(
          isSuccess: decodedResponse is Map && decodedResponse['success'] == true,
          statusCode: response.statusCode,
          responseData: decodedResponse,
          errorMessage: decodedResponse is Map ? (decodedResponse['message'] ?? '') : '',
        );
      }
    } else if (response.statusCode == 400) {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: decodedResponse is Map
            ? _extractErrorMessages(decodedResponse['errorSources'])
            : 'Bad Request',
      );
    } else if (response.statusCode == 500) {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: decodedResponse is Map
            ? (decodedResponse['message'] ?? 'An unexpected error occurred!')
            : 'Server Error',
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        responseData: decodedResponse,
        errorMessage: decodedResponse is Map
            ? (decodedResponse['message'] ?? 'An unknown error occurred')
            : 'Unknown Error',
      );
    }
  }

  String _extractErrorMessages(dynamic errorSources) {
    if (errorSources is List) {
      return errorSources
          .map((error) => error['message'] ?? 'Unknown error')
          .join(', ');
    }
    return 'Validation error';
  }

  ResponseData _handleError(dynamic error) {
    AppLoggerHelper.error('Request Error: $error');

    if (error is ClientException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Network error occurred. Please check your connection.',
      );
    } else if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        responseData: null,
        errorMessage: 'Request timeout. Please try again later.',
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        responseData: null,
        errorMessage: 'Unexpected error occurred.',
      );
    }
  }
}