import 'package:coco_mobile_explorer/features/search/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/image_builder.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchController searchController = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coco Mobile Explorer'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: searchController.searchTextEditingController,
                      decoration: InputDecoration(
                        hintText: 'Type in a search term',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                    onPressed: () {
                      searchController.startSearch();
                    },
                    child: const Text("Search"))
              ],
            ),
            const SizedBox(height: 20.0),
            Obx(
              () => searchController.isLoading.value
                  ? Container(
                      height: 50,
                      width: 50,
                      child: const CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: Obx(
                        () => ListView.builder(
                          controller: searchController.scrollController,
                          itemCount: searchController.searchResult.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: ImageBuilder(
                                searchController.imageList[index]["coco_url"],
                                searchController.segmentationList[index],
                                searchController.captionList[index],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
            Obx(
              () => searchController.isMoreLoading.value
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
