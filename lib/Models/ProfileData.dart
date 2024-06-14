import 'package:flutter/cupertino.dart';

class ProfileData {
  ProfileData({
    this.name = '',
    this.photo,
  });

  String name;
  ImageProvider? photo;
  static List<ProfileData> tabIconsList = <ProfileData>[
  ProfileData(
  name: "Amura Maulidi Fachry",
  photo: AssetImage("assets/images/rior.jpg"),
  )
  ];
}
