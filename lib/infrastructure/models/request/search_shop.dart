

import 'package:riverpodtemp/infrastructure/services/local_storage.dart';


class SearchShopModel {
  final String text;
  final int? categoryId;

  SearchShopModel({
    required this.text,
    this.categoryId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["search"] = text;
    map["perPage"] = 100;
    if(categoryId != null )  map["category_id"] = categoryId;
    map["lang"] = LocalStorage.getLanguage()?.locale ?? "en";
    return map;
  }
}
