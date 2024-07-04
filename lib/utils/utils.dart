import 'dart:math' show cos, sqrt, asin;

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double p = 0.017453292519943295; // Math.PI / 180
  final double c1 = cos((lat2 - lat1) * p);
  final double c2 = cos(lat1 * p);
  final double c3 = cos(lat2 * p);
  final double c4 = cos((lon2 - lon1) * p);

  final double a = 0.5 - c1 / 2 + c2 * c3 * (1 - c4) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}
