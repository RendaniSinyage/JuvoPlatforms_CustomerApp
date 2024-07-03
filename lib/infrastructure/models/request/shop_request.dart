import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';

import '../../services/app_constants.dart';

class ShopRequest {
  final int page;
  final int? take;
  final bool? freeDelivery;
  final bool? onlyOpen;
  final bool? deals;
  final String? rating;
  final List<double>? price;
  final String? orderBy;
  final int? categoryId;
  final bool? verify;

  ShopRequest(
      {this.orderBy,
      this.price,
      this.take,
      this.freeDelivery,
      this.onlyOpen,
      this.deals,
      this.rating,
      this.categoryId,
      this.verify,
      required this.page});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if(LocalStorage.getSelectedCurrency() != null)  map["currency_id"] = LocalStorage.getSelectedCurrency()?.id;
    if (price != null) {
      for (int i = 0; i < price!.length; i++) {
        map["prices[$i]"] = price?[i];
      }
    }
    map["page"] = page;
    if (take != null) {
      map["take"] = take;
    }
    if (verify != null) {
      map["verify"] = 1;
    }
    if (categoryId != null) {
      map["category_id"] = categoryId;
    }
    if (freeDelivery != null && (freeDelivery ?? false)) {
      map["free_delivery"] = freeDelivery;
    }
    if (deals != null && (deals ?? false)) {
      map["deals"] = deals;
    }
    if (onlyOpen != null && (onlyOpen ?? false)) {
      map["open"] = 1;
    }
    if (rating != null && (rating?.isNotEmpty ?? false)) {
      if (rating!.contains("-")) {
        map["rating[0]"] = rating!.substring(0, rating!.indexOf("-"));
        map["rating[1]"] = rating!.substring(rating!.indexOf("-") + 1);
      } else {
        map["rating[0]"] = rating;
      }
    }
    if (orderBy != null && (orderBy?.isNotEmpty ?? false)) {
      map["order_by"] = AppHelpers.getOrderByString(orderBy!);
    }
    map["perPage"] =AppHelpers.getType() ==3 ? 9:6;
    map["lang"] = LocalStorage.getLanguage()?.locale ?? "en";
    map["address"] = {
      "latitude":
          LocalStorage.getAddressSelected()?.location?.latitude ??
              AppConstants.demoLatitude,
      "longitude":
          LocalStorage.getAddressSelected()?.location?.longitude ??
              AppConstants.demoLongitude
    };
    return map;
  }
}
