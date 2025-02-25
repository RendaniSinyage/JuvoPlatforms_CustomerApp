class MembershipData {
  MembershipData({
    int? id,
    String? title,
    String? type,
    num? price,
    int? duration,
    String? durationUnit,
    String? startDate,
    String? endDate,
    bool? isActive,
    List<MembershipBenefit>? benefits,
  }) {
    _id = id;
    _title = title;
    _type = type;
    _price = price;
    _duration = duration;
    _durationUnit = durationUnit;
    _startDate = startDate;
    _endDate = endDate;
    _isActive = isActive;
    _benefits = benefits;
  }

  MembershipData.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _type = json['type'];
    _price = json['price'];
    _duration = json['duration'];
    _durationUnit = json['duration_unit'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _isActive = json['is_active'] != null
        ? json['is_active'].runtimeType == int
        ? (json['is_active'] == 1)
        : json['is_active']
        : false;

    if (json['benefits'] != null) {
      _benefits = [];
      json['benefits'].forEach((v) {
        _benefits?.add(MembershipBenefit.fromJson(v));
      });
    }
  }

  int? _id;
  String? _title;
  String? _type;
  num? _price;
  int? _duration;
  String? _durationUnit;
  String? _startDate;
  String? _endDate;
  bool? _isActive;
  List<MembershipBenefit>? _benefits;

  int? get id => _id;
  String? get title => _title;
  String? get type => _type;
  num? get price => _price;
  int? get duration => _duration;
  String? get durationUnit => _durationUnit;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  bool? get isActive => _isActive;
  List<MembershipBenefit>? get benefits => _benefits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['type'] = _type;
    map['price'] = _price;
    map['duration'] = _duration;
    map['duration_unit'] = _durationUnit;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['is_active'] = _isActive;
    if (_benefits != null) {
      map['benefits'] = _benefits?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class MembershipBenefit {
  MembershipBenefit({
    int? id,
    String? name,
    String? description,
    bool? enabled,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _enabled = enabled;
  }

  MembershipBenefit.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _enabled = json['enabled'] != null
        ? json['enabled'].runtimeType == int
        ? (json['enabled'] == 1)
        : json['enabled']
        : false;
  }

  int? _id;
  String? _name;
  String? _description;
  bool? _enabled;

  int? get id => _id;
  String? get name => _name;
  String? get description => _description;
  bool? get enabled => _enabled;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['description'] = _description;
    map['enabled'] = _enabled;
    return map;
  }
}