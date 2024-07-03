import 'package:riverpodtemp/infrastructure/services/local_storage.dart';

class ProductRequest {
  final String shopId;
  final int page;
  final int? categoryId;
  final List<int>? brands;

  ProductRequest({
    required this.shopId,
    required this.page,
    this.categoryId,
    this.brands,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["shop_id"] = shopId;
    map["lang"] = LocalStorage.getLanguage()?.locale ?? "en";
    if (LocalStorage.getSelectedCurrency() != null){
      map["currency_id"] = LocalStorage.getSelectedCurrency()?.id;
    }

    map["page"] = page;
    map["status"] = "published";
    map["perPage"] = 6;
    if (brands?.isNotEmpty ?? false) {
      map['brand_ids'] = brands?.map((v) => v).toList();
    }

    return map;
  }

  Map<String, dynamic> toJsonPopular() {
    final map = <String, dynamic>{};
    map["lang"] = LocalStorage.getLanguage()?.locale ?? "en";
    if (LocalStorage.getSelectedCurrency() != null){
      map["currency_id"] = LocalStorage.getSelectedCurrency()?.id;
    }

    map["page"] = page;
    map["status"] = "published";
    map["perPage"] = 6;
    if (brands?.isNotEmpty ?? false) {
      map['brand_ids'] = brands?.map((v) => v).toList();
    }
    return map;
  }

  Map<String, dynamic> toJsonByCategory() {
    final map = <String, dynamic>{};
    map["shop_id"] = shopId;
    map["lang"] = LocalStorage.getLanguage()?.locale ?? "en";
    if (LocalStorage.getSelectedCurrency() != null){
      map["currency_id"] = LocalStorage.getSelectedCurrency()?.id;
    }

    map["page"] = page;
    map["status"] = "published";
    map["category_id"] = categoryId;
    map["perPage"] = 6;
    if (brands?.isNotEmpty ?? false) {
      map['brand_ids'] = brands?.map((v) => v).toList();
    }
    return map;
  }
}
