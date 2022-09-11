// To parse this JSON data, do
//
//     final brandResponse = brandResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

PubsResponse pubsResponseFromJson(String str) => PubsResponse.fromJson(json.decode(str));

String pubsResponseToJson(PubsResponse data) => json.encode(data.toJson());

class PubsResponse {
  PubsResponse({
    this.pubs,
    this.meta,
    this.success,
    this.status,
  });

  List<Pubs> pubs;
  Meta meta;
  bool success;
  int status;

  factory PubsResponse.fromJson(Map<String, dynamic> json) => PubsResponse(
    pubs: List<Pubs>.from(json["data"].map((x) => Pubs.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(pubs.map((x) => x.toJson())),
    "meta": meta == null ? null : meta.toJson(),
    "success": success,
    "status": status,
  };
}

class Pubs {
  Pubs({
    this.id,
    this.id_shop,
    this.lb_shop,
    this.img,
  });

  int id;
  int id_shop;
  String lb_shop;
  String img;

  factory Pubs.fromJson(Map<String, dynamic> json) => Pubs(
    id_shop: json["id_shop"],
    id: json["id"],
    lb_shop: json["lb_shop"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id_shop": id_shop,
    "id": id,
    "lb_shop": lb_shop,
    "img": img,
  };
}



class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}
