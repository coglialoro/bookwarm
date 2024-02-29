import "package:bookwarm/modelli/libro.dart";

class RisultatoAPI {
  int? totalItems;
  List<Items>? items;

  RisultatoAPI({this.totalItems, this.items});

  RisultatoAPI.fromJson(Map<String, dynamic> json) {
    totalItems = json["totalItems"];
    if (json["items"] != null) {
      items = <Items>[];
      json["items"].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
}

class Items {
  Libro? volumeInfo;

  Items({
    this.volumeInfo,
  });

  Items.fromJson(Map<String, dynamic> json) {
    volumeInfo =
        json["volumeInfo"] != null ? Libro.fromJson(json["volumeInfo"]) : null;
  }
}
