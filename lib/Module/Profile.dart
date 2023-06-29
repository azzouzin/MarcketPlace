import 'dart:io';

class Profile {
  late String? name;
  late String? prenome;
  late String? gender;
  late File? image_pro;

  Profile({
    this.prenome,
    this.gender,
    this.image_pro,
    this.name,
  });
}
