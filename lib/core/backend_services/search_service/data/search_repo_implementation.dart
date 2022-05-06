import 'package:dio/dio.dart';

import '../../api.dart';
import '../../api_endpoints.dart';
import '../domain/search_repository.dart';

class SearchRepositoryImplementation implements SearchRepository {
  final BackendService _api = BackendService(Dio());

  get getSetHeaders => _api.setExtraHeaders;

  @override
  getImagesId(query) async {
    try {
      return await _api.dio.post(Endpoints.baseurl, data: query);
    } on DioError catch (e) {
      return _api.handleError(e);
    }
  }

  @override
  getImagesUrl(query) async {
    try {
      return await _api.dio.post(Endpoints.baseurl, data: query);
    } on DioError catch (e) {
      return _api.handleError(e);
    }
  }

  @override
  getImagesSegmentation(query) async {
    try {
      return await _api.dio.post(Endpoints.baseurl, data: query);
    } on DioError catch (e) {
      return _api.handleError(e);
    }
  }

  @override
  getImagesCaption(query) async {
    try {
      return await _api.dio.post(Endpoints.baseurl, data: query);
    } on DioError catch (e) {
      return _api.handleError(e);
    }
  }
}
