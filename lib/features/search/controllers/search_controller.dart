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
  List<dynamic> imageList = [];
  List<dynamic> segmentationList = [];
  List<dynamic> captionList = [];
  RxBool isLoading = false.obs;
  RxBool isMoreLoading = false.obs;
  int n = 0;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        // page++;
        startSearch(more: true);
      }
    });
    super.onInit();
  }

  final SearchService _searchService = SearchService(SearchRepositoryImplementation());

  /// Get `Ids` of images that pertains to the search query
  startSearch({bool more = false}) async {
    categoryIds.clear();
    mapIds.forEach((key, value) {
      if (searchTextEditingController.text.trim().toLowerCase() == value.toLowerCase()) {
        categoryIds.add(key);
      }
    });
    // Search activates only when you type in the right Keyword
    if (categoryIds.isEmpty) {
      Get.snackbar(
        "Incorrect Keyword",
        "Please input a valid keyword",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    imageIds.clear();
    imageList.clear();
    segmentationList.clear();
    captionList.clear();
    Map<String, dynamic> queryParams = {
      "category_ids": categoryIds,
      "querytype": "getImagesByCats",
    };
    debugPrint("searching...");

    if (more) {
      isMoreLoading.value = true;
    } else {
      isLoading.value = true;
    }
    var res = await _searchService.getImagesId(queryParams);
    isLoading.value = false;
    isMoreLoading.value = false;
    if (res.valid!) {
      debugPrint(res.data?.length.toString());
      debugPrint("RESULT ==============++++> ${res.data![0].toString()}", wrapWidth: 1024);
      // Loop through the result five at a time to get the ids to make use later
      for (var i = n; i < n + 5; i++) {
        imageIds.add(res.data![i]);
      }
      print("=====ImageIDS $imageIds");
      n += 4;

      // Make simultaneous requests to get the images url,
      // segmentations and captions using the `ids`
      Future.wait([searchImagesUrl(), getImagesSegmentation(), getImagesCaption()]).then((value) {
        imageIds.clear();
        searchResult.addAll(imageList);
        print(" SEARCH RESULT: ${searchResult.length}");
      });
    } else {
      debugPrint("======checking================> ${res.message}", wrapWidth: 1024);
    }
  }

  /// Request to get the images url using the `ids`
  Future<void> searchImagesUrl() async {
    Map<String, dynamic> queryParams = {
      "image_ids": imageIds,
      "querytype": "getImages",
    };
    print(queryParams);

    var res = await _searchService.getImagesUrl(queryParams);
    // if (res.valid!) {
    debugPrint(res.data.runtimeType.toString());
    debugPrint("RESULT URL==============++++> ${res.data?[0]}", wrapWidth: 1024);
    imageList.addAll(res.data);
  }

  /// Request to get the segmentation of the images using the `ids`
  Future<void> getImagesSegmentation() async {
    Map<String, dynamic> queryParams = {
      "image_ids": imageIds,
      "querytype": "getInstances",
    };

    var res = await _searchService.getImageSegmentation(queryParams);
    // if (res.valid!) {
    debugPrint(res.data?.length.toString());
    debugPrint("RESULT URL==============++++> ${res.data[0]["segmentation"]}", wrapWidth: 1024);
    segmentationList.addAll(res.data);
  }

  /// Request to get the captions of the images by their `ids`
  Future<void> getImagesCaption() async {
    Map<String, dynamic> queryParams = {
      "image_ids": imageIds,
      "querytype": "getCaptions",
    };

    var res = await _searchService.getImagesCaption(queryParams);
    // if (res.valid!) {
    debugPrint(res.data?.length.toString());
    debugPrint("RESULT URL==============++++> ${res.data[0]["caption"]}", wrapWidth: 1024);
    captionList.addAll(res.data);
  }
}
