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
  Stato stato;

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

  // Libro copyWith({
  //   String? titolo,
  //   String? autore,
  //   int? pagine,
  //   String? casaEditrice,
  //   String? descrizione,
  //   String? copertina,
  //   Stato? stato,
  // }) =>
  //     Libro(
  //       titolo: titolo ?? this.titolo,
  //       autore: autore ?? this.autore,
  //       pagine: pagine ?? this.pagine,
  //       casaEditice: casaEditice ?? casaEditice,
  //       isbn: isbn,
  //       descrizione: descrizione ?? this.descrizione,
  //       copertina: copertina ?? this.copertina,
  //       stato: stato ?? this.stato,
  //     );

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
}
