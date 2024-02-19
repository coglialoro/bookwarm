import "package:bookwarm/modelli/sessione.dart";
import "package:hive/hive.dart";

part "libro.g.dart";

@HiveType(typeId: 2)
enum Stato {
  @HiveField(0)
  daLeggere,
  @HiveField(1)
  inLettura,
  @HiveField(2)
  finito,
}

@HiveType(typeId: 0)
class Libro extends HiveObject {
  @HiveField(0)
  String titolo;
  @HiveField(1)
  String autore;
  @HiveField(2)
  int pagine;
  @HiveField(3)
  String? casaEditice;
  @HiveField(4)
  String isbn;
  @HiveField(5)
  String? descrizione;
  @HiveField(6)
  String? copertina;
  @HiveField(7)
  Stato stato = Stato.daLeggere;
  @HiveField(8)
  List<Sessione> sessioni = [];

  Libro(
      {required this.titolo,
      required this.autore,
      required this.pagine,
      this.casaEditice,
      required this.isbn,
      this.descrizione,
      this.copertina});
}
