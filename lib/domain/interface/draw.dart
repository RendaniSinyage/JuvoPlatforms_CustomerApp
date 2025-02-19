import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodyman/infrastructure/models/response/draw_routing_response.dart';

import '../handlers/handlers.dart';

abstract class DrawRepositoryFacade {
  Future<ApiResult<DrawRouting>> getRouting({
    required LatLng start,
    required LatLng end,
  });
}
