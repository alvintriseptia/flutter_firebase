class UserModel {
  final String? uid;

  UserModel({required this.uid});
}

class UserData {
  String? uid;
  String? name;
  String? sugars;
  double? strength;

  UserData({this.uid, this.name, this.sugars, this.strength});
}
