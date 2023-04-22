class UserModel {
  int? id;
  String? userName;
  String? userEmail;
  String? userPassword;

  UserModel({this.userName, this.userEmail, this.userPassword});

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userEmail = json['userEmail'];
    userPassword = json['userPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['userPassword'] = userPassword;
    return data;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    userName = map["userName"];
    userEmail = map["userEmail"];
    userPassword = map["userPassword"];
  }


  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      "userName": userName,
      "userEmail": userEmail,
      "userPassword": userPassword
    };
    return map;
  }
}
