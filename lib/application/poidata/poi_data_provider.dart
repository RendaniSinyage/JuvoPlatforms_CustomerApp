// poi_data_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtemp/infrastructure/models/data/poi_data.dart';

final poiDataProvider = StateNotifierProvider<POIDataNotifier, List<POIData>>((ref) {
  return POIDataNotifier();
});

class POIDataNotifier extends StateNotifier<List<POIData>> {
  POIDataNotifier() : super([]);

  void updatePOIData(List<POIData> newData) {
    state = newData;
  }
} 