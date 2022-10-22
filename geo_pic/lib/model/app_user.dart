class AppUser {
  late String idU;
  late String username;
  late String e_mail;

  AppUser(String id, String us, String em) {
    idU = id;
    username = us;
    e_mail = em;
  }

  AppUser.fromJson(Map<dynamic, dynamic> json)
      : idU = json['id'] as String,
        username = json['username'] as String,
        e_mail = json['e_mail'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': idU,
        'username': username,
        'e_mail': e_mail,
      };
}
