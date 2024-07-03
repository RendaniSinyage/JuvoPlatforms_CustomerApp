class AddressInformation {
  AddressInformation({
    String? address,
    String? house,
    String? floor,
  }) {
    _address = address;
    _house = house;
    _floor = floor;
  }

  AddressInformation.fromJson(dynamic json) {
    _address = json?['address'];
    _house = json?['house'];
    _floor = json?['floor'];
  }

  String? _address;
  String? _house;
  String? _floor;

  AddressInformation copyWith({
    String? address,
    String? house,
    String? floor,
  }) =>
      AddressInformation(
        address: address ?? _address,
        house: house ?? _house,
        floor: floor ?? _floor,
      );

  String? get address => _address;

  String? get house => _house;

  String? get floor => _floor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['house'] = _house;
    map['floor'] = _floor;
    return map;
  }
}
