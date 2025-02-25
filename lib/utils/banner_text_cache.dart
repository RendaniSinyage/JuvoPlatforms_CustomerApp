class BannerTextCache {
  static final Map<int, String> _buttonTexts = {};

  static void storeButtonText(int? bannerId, String? buttonText) {
    if (bannerId != null && buttonText != null) {
      print("CACHE DEBUG: Storing '$buttonText' for banner ID: $bannerId");
      _buttonTexts[bannerId] = buttonText;
      print("CACHE DEBUG: Cache contents: $_buttonTexts");
    }
  }

  static String? getButtonText(int? bannerId) {
    if (bannerId == null) return null;
    String? result = _buttonTexts[bannerId];
    print("CACHE DEBUG: Retrieved '${result}' for banner ID: $bannerId");
    return result;
  }
}