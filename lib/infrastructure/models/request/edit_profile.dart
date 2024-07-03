class EditProfile {
  String? firstname;
  String? lastname;
  String? birthday;
  String? gender;
  String? phone;
  String? secondPhone;
  String? images;
  String? email;

  EditProfile(
      {this.firstname,
      this.lastname,
      this.birthday,
      this.gender,
      this.phone,
      this.secondPhone,
      this.email,
      this.images});

  EditProfile.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    birthday = json['birthday'];
    gender = json['gender'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (firstname != null) data['firstname'] = firstname;
    if (lastname != null) data['lastname'] = lastname;
    if (email != null) data['email'] = email;
    if (lastname != null) {
      data['birthday'] = birthday!.contains(" ")
        ? birthday?.substring(0, birthday?.indexOf(" "))
        : birthday;
    }
    if (gender != null) data['gender'] = gender;
    if (images != null && images!.isNotEmpty) data["images"] = [images];
    data["phone"] = phone;
    return data;
  }
}
