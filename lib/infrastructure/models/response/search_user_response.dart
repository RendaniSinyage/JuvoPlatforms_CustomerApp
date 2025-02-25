

import '../data/help_data.dart';
import '../data/user.dart';

class SearchUserResponse {
  List<UserModel>? data;
  Links? links;
  Meta? meta;

  SearchUserResponse({
    this.data,
    this.links,
    this.meta,
  });

  SearchUserResponse copyWith({
    List<UserModel>? data,
    Links? links,
    Meta? meta,
  }) =>
      SearchUserResponse(
        data: data ?? this.data,
        links: links ?? this.links,
        meta: meta ?? this.meta,
      );

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) => SearchUserResponse(
    data: json["data"] == null ? [] : List<UserModel>.from(json["data"]!.map((x) => UserModel.fromJson(x))),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

