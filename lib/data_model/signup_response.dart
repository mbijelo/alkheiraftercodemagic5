// To parse this JSON data, do
//
//     final signupResponse = signupResponseFromJson(jsonString);

import 'dart:convert';

SignupResponse signupResponseFromJson(String str) => SignupResponse.fromJson(json.decode(str));

String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());

class SignupResponse {
  SignupResponse({
    this.result,
    this.message,
    this.user_id,
    this.code,
  });

  bool result;
  String message;
  int user_id;
  String code;

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
    result: json["result"],
    message: json["message"],
    user_id: json["user_id"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "user_id": user_id,
    "code": code,
  };
}