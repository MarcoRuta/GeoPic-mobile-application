class UserImage {
  late String Userid;
  late String username;
  late String downloadUrl;
  late String description;
  late String place;
  late double lat;
  late double lon;


  UserImage(String id, String username, String download, String description,
      double lat, double lon, String place) {
    this.Userid = id;
    this.username = username;
    this.downloadUrl = download;
    this.description = description;
    this.lat = lat;
    this.lon = lon;
    this.place = place;
  }

  UserImage.fromJson(Map<dynamic, dynamic> json)
      : Userid = json['Userid'] as String,
        username = json['username'] as String,
        downloadUrl = json['downloadUrl'] as String,
        description = json['description'] as String,
        lat = json['lat'] as double,
        lon = json['lon'] as double,
        place = json['place'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'Userid': Userid,
        'username': username,
        'downloadUrl': downloadUrl,
        'description': description,
        'lat': lat,
        'lon': lon,
        'place': place,
      };

  bool equals(UserImage e1, UserImage e2) => (e1.downloadUrl == e2.downloadUrl)
      && (e1.Userid == e2.Userid)
      && (e1.lat*e2.lon == e1.lat*e1.lon);
}
