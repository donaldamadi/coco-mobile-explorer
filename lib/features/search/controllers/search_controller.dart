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
  ScrollController scrollController = ScrollController();

  // I was not able to get the search result to update when the user types in the search bar
  // I have not been able to figure out the appropriate request body to make the right API calls for
  //searchImagesUrl, getImagesSegmentation and getImagesCaption
  // Given more time, I will be able to accomplish these

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // page++;
        startSearch();
      }
    });
    super.onInit();
  }

  final SearchService _searchService =
      SearchService(SearchRepositoryImplementation());

  search(String query) {
    startSearch();
  }

  /// Get `Ids` of images that pertains to the search query
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

    // Loop through the result five at a time to get the ids
    for (var i = n; i < n + 5; i++) {
      imageIds.add(res.data![i].id!);
    }
    print("=====ImageIDS $imageIds");
    n += 5;

    // Make simultaneous requests to get the images url,
    // segmentation and captions using the `ids`
    Future.wait(
        [searchImagesUrl(), getImagesSegmentation(), getImagesCaption()]);
  }

  /// Request to get the images url using the `ids`
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

  /// Request to get the segmentation of the images using the `ids`
  Future<void> getImagesSegmentation() async {
    Map<String, dynamic> queryParams = {
      "image_ids": imageIds,
      "querytype": "getInstances",
    };

    var res = await _searchService.getImageSegmentation(queryParams);
    if (res.valid!) {
      debugPrint(res.data?.length.toString());
      debugPrint(
          "RESULT URL==============++++> ${res.data?.first.segmentation}",
          wrapWidth: 1024);
    } else {
      debugPrint("======checking================> ${res.message}",
          wrapWidth: 1024);
    }
  }

  /// Request to get the captions of the images by their `ids`
  Future<void> getImagesCaption() async {
    Map<String, dynamic> queryParams = {
      "image_ids": imageIds,
      "querytype": "getCaptions",
    };

    var res = await _searchService.getImagesCaption(queryParams);
    if (res.valid!) {
      debugPrint(res.data?.length.toString());
      debugPrint("RESULT URL==============++++> ${res.data?.first.caption}",
          wrapWidth: 1024);
    } else {
      debugPrint("======checking================> ${res.message}",
          wrapWidth: 1024);
    }
  }
}
