class UserProfileModel {
  final String email;
  final String name;
  final String uid;
  final String imageURL;
  final String token;
  final String country;
  final String nickName;

  UserProfileModel(
      {required this.nickName,
      required this.imageURL,
      required this.email,
      required this.name,
      required this.uid,
      required this.token,
      required this.country});

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        imageURL = "",
        token = "",
        country = "",
        nickName = "";

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        imageURL = json["imageURL"],
        token = json['token'],
        country = json['country'],
        nickName = json['nickName'];

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "imageURL": imageURL,
      "country": country,
      "nickName": nickName
    };
  }
}
