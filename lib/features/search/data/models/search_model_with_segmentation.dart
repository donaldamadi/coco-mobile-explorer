// To parse this JSON data, do
//
//     final searchModelWithSegmentation = searchModelWithSegmentationFromJson(jsonString);

import 'dart:convert';

List<SearchModelWithSegmentation> searchModelWithSegmentationFromJson(String str) => List<SearchModelWithSegmentation>.from(json.decode(str).map((x) => SearchModelWithSegmentation.fromJson(x)));

String searchModelWithSegmentationToJson(List<SearchModelWithSegmentation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchModelWithSegmentation {
    SearchModelWithSegmentation({
        this.imageId,
        this.segmentation,
        this.categoryId,
    });

    int? imageId;
    String? segmentation;
    int? categoryId;

    factory SearchModelWithSegmentation.fromJson(Map<String, dynamic> json) => SearchModelWithSegmentation(
        imageId: json["image_id"],
        segmentation: json["segmentation"],
        categoryId: json["category_id"],
    );

    Map<String, dynamic> toJson() => {
        "image_id": imageId,
        "segmentation": segmentation,
        "category_id": categoryId,
    };
}
