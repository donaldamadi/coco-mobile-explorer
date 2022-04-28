// To parse this JSON data, do
//
//     final searchModelWithId = searchModelWithIdFromJson(jsonString);

import 'dart:convert';

List<SearchModelWithId> searchModelWithIdFromJson(String str) => List<SearchModelWithId>.from(json.decode(str).map((x) => SearchModelWithId.fromJson(x)));

String searchModelWithIdToJson(List<SearchModelWithId> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchModelWithId {
    SearchModelWithId({
        this.id,
    });

    int? id;

    factory SearchModelWithId.fromJson(Map<String, dynamic> json) => SearchModelWithId(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
