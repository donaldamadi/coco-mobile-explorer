import 'package:coco_mobile_explorer/core/backend_services/search_service/data/map.dart';
import 'package:coco_mobile_explorer/core/backend_services/search_service/data/search_repo_implementation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/backend_services/search_service/data/search_service.dart';

class SearchController extends GetxController {
  TextEditingController searchTextEditingController = TextEditingController();
  RxList searchResult = [].obs;
  List<int> imageIds = [];
  List<int> categoryIds = [];
  RxBool isLoading = false.obs;
  int n = 0;

  final SearchService _searchService =
      SearchService(SearchRepositoryImplementation());

  search(String query) {
    startSearch();
  }

  startSearch() async {
    mapIds.forEach((key, value) {
      if (searchTextEditingController.text.trim() == value) {
        categoryIds.add(key);
      }
    });
    Map<String, dynamic> queryParams = {
      "category_ids": categoryIds,
      "querytype": "getImagesByCats",
    };
    debugPrint("searching...");

    isLoading.value = true;
    var res = await _searchService.getImagesId(queryParams);
    isLoading.value = false;
    if (res.valid!) {
      debugPrint(res.data?.length.toString());
      debugPrint("RESULT ==============++++> ${res.data![0].toString()}",
          wrapWidth: 1024);
    } else {
      debugPrint("======checking================> ${res.message}",
          wrapWidth: 1024);
    }
    imageIds.clear();
    for (var i = n; i < n + 5; i++) {
      imageIds.add(res.data![i].id!);
    }
    print("=====ImageIDS $imageIds");
    n += 5;

    Future.wait([searchImagesUrl()]);
  }

  Future<void> searchImagesUrl() async {
    Map<String, dynamic> queryParams = {
      "image_ids": imageIds,
      "querytype": "getImages",
    };

    var res = await _searchService.getImagesUrl(queryParams);
    if (res.valid!) {
      debugPrint(res.data?.length.toString());
      debugPrint("RESULT URL==============++++> ${res.data?.first.flickrUrl}",
          wrapWidth: 1024);
    } else {
      debugPrint("======checking================> ${res.message}",
          wrapWidth: 1024);
    }
  }
}
