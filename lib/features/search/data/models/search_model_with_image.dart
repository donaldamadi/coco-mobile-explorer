// To parse this JSON data, do
//
//     final searchModelWithImage = searchModelWithImageFromJson(jsonString);

import 'dart:convert';

List<SearchModelWithImage> searchModelWithImageFromJson(String str) => List<SearchModelWithImage>.from(json.decode(str).map((x) => SearchModelWithImage.fromJson(x)));

String searchModelWithImageToJson(List<SearchModelWithImage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchModelWithImage {
    SearchModelWithImage({
        this.id,
        this.cocoUrl,
        this.flickrUrl,
    });

    int? id;
    String? cocoUrl;
    String? flickrUrl;

    factory SearchModelWithImage.fromJson(Map<String, dynamic> json) => SearchModelWithImage(
        id: json["id"],
        cocoUrl: json["coco_url"],
        flickrUrl: json["flickr_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "coco_url": cocoUrl,
        "flickr_url": flickrUrl,
    };
}
