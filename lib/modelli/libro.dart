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
  late String titolo;
  @HiveField(1)
  late String autore;
  @HiveField(2)
  late int pagine;
  @HiveField(3)
  String? casaEditice;
  @HiveField(4)
  late String isbn;
  @HiveField(5)
  String? descrizione;
  @HiveField(6)
  String? copertina;
  @HiveField(7)
  late Stato stato;

  static Box<Sessione> boxSessioni = Hive.box<Sessione>("sessioni");
  @HiveField(8)
  HiveList<Sessione> sessioni = HiveList(boxSessioni);

  Libro({
    required this.titolo,
    required this.autore,
    required this.pagine,
    this.casaEditice,
    required this.isbn,
    this.descrizione,
    this.copertina,
    this.stato = Stato.daLeggere,
  });

  String getStatoString() {
    switch (stato) {
      case Stato.daLeggere:
        return "Da leggere";
      case Stato.inLettura:
        return "In lettura";
      case Stato.finito:
        return "Finito";
    }
  }

  int getUltimaPagina() {
    return sessioni.fold(
        0, (int value, sessione) => value + sessione.pagineLette);
  }

  void aggiungiSessione(int pagine, Duration durata) async {
    final sessione =
        Sessione(pagineLette: pagine, durata: durata.inMilliseconds);
    await boxSessioni.add(sessione);
    sessioni.add(sessione);
  }

  Libro.fromJson(Map<String, dynamic> json) {
    titolo = json["title"];
    autore = json["authors"].cast<String>()[0];
    pagine = json["pageCount"];
    isbn = json["industryIdentifiers"][1]["identifier"];
    copertina = json["imageLinks"]["thumbnail"];
    stato = Stato.daLeggere;
  }
}
