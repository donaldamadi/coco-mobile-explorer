import 'dart:convert';

import 'package:coco_mobile_explorer/core/backend_services/api_response_model.dart';
import 'package:coco_mobile_explorer/core/backend_services/search_service/data/search_repo_implementation.dart';
import 'package:coco_mobile_explorer/features/search/data/models/search_model_with_caption.dart';
import 'package:coco_mobile_explorer/features/search/data/models/search_model_with_ids.dart';
import 'package:coco_mobile_explorer/features/search/data/models/search_model_with_image.dart';
import 'package:coco_mobile_explorer/features/search/data/models/search_model_with_segmentation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SearchService {
  final SearchRepositoryImplementation _implementation;

  SearchService(this._implementation);

  Future<ResponseModel<List<dynamic>>> getImagesId(Map<String, dynamic> query) async {
    var response = await _implementation.getImagesId(query);

    int statusCode = response.statusCode ?? 000;

    debugPrint('============================>: [INFO] $response');
    debugPrint('============================>: [TYPE] ${response.runtimeType}');

    if (statusCode >= 200 && statusCode <= 300) {
      return ResponseModel<List<dynamic>>(valid: true, message: response.data[0], statusCode: statusCode, data: response.data
          // data: List<SearchModelWithId>.from(
          //     response.data.map((model) => SearchModelWithId.fromJson(model))),
          );
    }

    return ResponseModel(
      valid: false,
      statusCode: response.statusCode,
      message: response.data["message"],
      error: ErrorModel.fromJson(response.data),
    );
  }

  Future<dynamic> getImagesUrl(Map<String, dynamic> query) async {
    var response = _implementation.getImagesUrl(query);

    debugPrint('============================>>>>: [INFO] $response');

    // int statusCode = response.statusCode ?? 000;

    // if (statusCode >= 200 && statusCode <= 300) {
    // return ResponseModel<dynamic>(
    //   valid: true,
    //   message: response,
    //   statusCode: 000,
    //   data: response
    //   // data: List<SearchModelWithImage>.from(
    //   //     response.map((model) => SearchModelWithImage.fromJson(model))),
    // );
    // }

    return response;

    // return ResponseModel(
    //   valid: false,
    //   statusCode: response.statusCode,
    //   message: response.data["message"],
    //   error: ErrorModel.fromJson(response.data),
    // );
  }

  Future<dynamic> getImageSegmentation(Map<String, dynamic> query) async {
    var response = _implementation.getImagesSegmentation(query);

    // int statusCode = response.statusCode ?? 000;

    // debugPrint('============================>: [INFO] $response');
    // debugPrint('============================>: [TYPE] ${response.runtimeType}');

    // if (statusCode >= 200 && statusCode <= 300) {
    //   return ResponseModel<List<SearchModelWithSegmentation>>(
    //     valid: true,
    //     message: response.data["message"],
    //     statusCode: statusCode,
    //     data: List<SearchModelWithSegmentation>.from(response.data.map((model) => SearchModelWithSegmentation.fromJson(model))),
    //   );
    // }

    return response;

    // return ResponseModel(
    //   valid: false,
    //   statusCode: response.statusCode,
    //   message: response.data["message"],
    //   error: ErrorModel.fromJson(response.data),
    // );
  }

  Future<dynamic> getImagesCaption(Map<String, dynamic> query) async {
    var response = _implementation.getImagesCaption(query);

    // int statusCode = response.statusCode ?? 000;

    debugPrint('============================>: [INFO] $response');

    return response;

    // if (statusCode >= 200 && statusCode <= 300) {
    //   return ResponseModel<List<SearchModelWithCaption>>(
    //     valid: true,
    //     message: response.data["message"],
    //     statusCode: statusCode,
    //     data: List<SearchModelWithCaption>.from(response.data.map((model) => SearchModelWithCaption.fromJson(model))),
    //   );
    // }

    // return ResponseModel(
    //   valid: false,
    //   statusCode: response.statusCode,
    //   message: response.data["message"],
    //   error: ErrorModel.fromJson(response.data),
    // );
  }
}
