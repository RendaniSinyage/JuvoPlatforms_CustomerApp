import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';

class BannersRequest {
  final int page;
  final int perPage;

  BannersRequest({
    required this.page,
    this.perPage = 4,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["page"] = page;
    map["perPage"] = perPage;
    map["lang"] = LocalStorage.getLanguage()?.locale ?? "en";
    map["address"] = {
      "latitude": LocalStorage.getAddressSelected()?.location?.latitude ??
          AppConstants.demoLatitude,
      "longitude": LocalStorage.getAddressSelected()?.location?.longitude ??
          AppConstants.demoLongitude
    };
    return map;
  }
}
