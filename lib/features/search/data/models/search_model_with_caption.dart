// To parse this JSON data, do
//
//     final searchModelWithCaption = searchModelWithCaptionFromJson(jsonString);

import 'dart:convert';

List<SearchModelWithCaption> searchModelWithCaptionFromJson(String str) => List<SearchModelWithCaption>.from(json.decode(str).map((x) => SearchModelWithCaption.fromJson(x)));

String searchModelWithCaptionToJson(List<SearchModelWithCaption> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchModelWithCaption {
    SearchModelWithCaption({
        this.caption,
        this.imageId,
    });

    String? caption;
    int? imageId;

    factory SearchModelWithCaption.fromJson(Map<String, dynamic> json) => SearchModelWithCaption(
        caption: json["caption"],
        imageId: json["image_id"],
    );

    Map<String, dynamic> toJson() => {
        "caption": caption,
        "image_id": imageId,
    };
}
