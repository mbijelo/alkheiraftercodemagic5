// To parse this JSON data, do
//
//     final languageListResponse = languageListResponseFromJson(jsonString);

import 'dart:convert';

LanguageListResponse1 languageListResponseFromJson1(String str) => LanguageListResponse1.fromJson(json.decode(str));

String languageListResponseToJson1(LanguageListResponse1 data) => json.encode(data.toJson());

class LanguageListResponse1 {
  LanguageListResponse1({
    this.languages,
    this.success,
    this.status,
  });

  List<Language> languages;
  bool success;
  int status;

  factory LanguageListResponse1.fromJson(Map<String, dynamic> json) => LanguageListResponse1(
    languages: List<Language>.from(json["data"].map((x) => Language.fromJson(x))),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(languages.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class Language {
  Language({
    this.id,
    this.name,
    this.image,
    this.code,
    this.mobile_app_code,
    this.rtl,
    this.is_default,

     this.image1,
     this.description,
     this.phone1,
     this.phone2,
     this.phone3,
     this.email1,
     this.email2,
     this.email3,
  });

  int id;
  String name;
  String image;
  String code;
  String mobile_app_code;
  bool rtl;
  bool is_default;

  String image1;
  String description;
  String phone1;
  String phone2;
  String phone3;
  String email1;
  String email2;
  String email3;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    code: json["code"],
    mobile_app_code: json["mobile_app_code"],
    rtl: json["rtl"],
    is_default: json["is_default"],

    image1: json["image1"],
    description: json["description"],
    phone1: json["phone1"],
    phone2: json["phone2"],
    phone3: json["phone3"],
    email1: json["email1"],
    email2: json["email2"],
    email3: json["email3"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "code": code,
    "mobile_app_code": mobile_app_code,
    "rtl": rtl,
    "is_default": is_default,

    "image1": image1,
    "description": description,
    "phone1": phone1,
    "phone2": phone2,
    "phone3": phone3,
    "email1": email1,
    "email2": email2,
    "email3": email3,
  };
}
