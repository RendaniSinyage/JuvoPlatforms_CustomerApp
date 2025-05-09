import 'address_new_data.dart';

class UserModel {
  UserModel({
    int? id,
    String? uuid,
    String? firstname,
    String? lastname,
    String? referral,
    String? email,
    String? phone,
    String? birthday,
    String? gender,
    String? emailVerifiedAt,
    String? registeredAt,
    bool? active,
    String? img,
    String? role,
    String? password,
    String? confirmPassword,
    List<AddressNewModel>? addresses,
  }) {
    _id = id;
    _uuid = uuid;
    _firstname = firstname;
    _lastname = lastname;
    _referral = referral;
    _email = email;
    _phone = phone;
    _birthday = birthday;
    _gender = gender;
    _emailVerifiedAt = emailVerifiedAt;
    _registeredAt = registeredAt;
    _active = active;
    _img = img;
    _role = role;
    _password = password;
    _addresses = addresses;
    _confirmPassword = confirmPassword;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'] ?? 0;
    _uuid = json['uuid'];
    _firstname = json['firstname'];
    _lastname = json['lastname'];
    _email = json['email'];
    _phone = json['phone'];
    _birthday = json['birthday'];
    _gender = json['gender'];
    _emailVerifiedAt = json['email_verified_at'];
    _registeredAt = json['registered_at'];
    _active = json['active'].runtimeType == int
        ? (json['active'] != 0)
        : json['active'];
    _img = json['img'];
    _role = json['role'];
    if (json['addresses'] != null) {
      _addresses = [];
      json['addresses'].forEach((v) {
        _addresses?.add(AddressNewModel.fromJson(v));
      });
    }
  }

  int? _id;
  String? _uuid;
  String? _firstname;
  String? _lastname;
  String? _referral;
  String? _email;
  String? _phone;
  String? _birthday;
  String? _gender;
  String? _emailVerifiedAt;
  String? _registeredAt;
  bool? _active;
  String? _img;
  String? _role;
  String? _password;
  String? _confirmPassword;
  List<AddressNewModel>? _addresses;

  UserModel copyWith({
    int? id,
    String? uuid,
    String? firstname,
    String? lastname,
    String? referral,
    String? email,
    String? phone,
    String? birthday,
    String? gender,
    String? emailVerifiedAt,
    String? registeredAt,
    bool? active,
    String? img,
    String? role,
    String? password,
    String? conPassword,
    List<AddressNewModel>? addresses,
  }) =>
      UserModel(
        id: id ?? _id,
        uuid: uuid ?? _uuid,
        firstname: firstname ?? _firstname,
        lastname: lastname ?? _lastname,
        referral: referral ?? _referral,
        email: email ?? _email,
        phone: phone ?? _phone,
        birthday: birthday ?? _birthday,
        gender: gender ?? _gender,
        emailVerifiedAt: emailVerifiedAt ?? _emailVerifiedAt,
        registeredAt: registeredAt ?? _registeredAt,
        active: active ?? _active,
        img: img ?? _img,
        role: role ?? _role,
        confirmPassword: conPassword ?? _confirmPassword,
        password: password ?? _password,
        addresses: addresses ?? _addresses,
      );

  int? get id => _id;

  String? get uuid => _uuid;

  String? get firstname => _firstname;

  String? get lastname => _lastname;

  String? get referral => _referral;

  String? get email => _email;

  String? get phone => _phone;

  String? get birthday => _birthday;

  String? get gender => _gender;

  String? get emailVerifiedAt => _emailVerifiedAt;

  String? get registeredAt => _registeredAt;

  bool? get active => _active;

  String? get img => _img;

  String? get role => _role;

  List<AddressNewModel>? get addresses => _addresses;

  String? get password => _password;

  String? get conPassword => _confirmPassword;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uuid'] = _uuid;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['referral'] = _referral;
    map['email'] = _email;
    map['phone'] = _phone;
    map['birthday'] = _birthday;
    map['gender'] = _gender;
    map['email_verified_at'] = _emailVerifiedAt;
    map['registered_at'] = _registeredAt;
    map['active'] = _active;
    map['img'] = _img;
    map['role'] = _role;
    if (_addresses != null) {
      map['addresses'] = _addresses?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Map<String, dynamic> toJsonForSignUp({typeFirebase = false}) => {
        "firstname": _firstname,
        if (_lastname?.isNotEmpty ?? false) "lastname": _lastname,
        if (_phone?.isNotEmpty ?? false) "phone": _phone?.replaceAll('+', ""),
        if (_email?.isNotEmpty ?? false) "email": _email,
        if (_password?.isNotEmpty ?? false) "password": _password,
        if (_confirmPassword?.isNotEmpty ?? false)
          "password_conformation": _confirmPassword,
        if (_referral?.isNotEmpty ?? false) 'referral': _referral,
        if (typeFirebase) "type": "firebase",
      };
}
