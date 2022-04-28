import 'package:coco_mobile_explorer/features/search/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        title: const Text('Search Page'),
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
                        hintText: 'Search',
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
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
