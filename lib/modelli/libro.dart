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

// La nostra classe eredita da `HiveObject` per poter
// essere salvata nel database
@HiveType(typeId: 0)
class Libro extends HiveObject {
  // Annotiamo i campi che vogliamo nel database con `HiveField`
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

  // Utilizziamo una `HiveList` per gestire le sessioni
  // visto che sono anch'esse `HiveObject`
  @HiveField(8)
  HiveList<Sessione> sessioni = HiveList(boxSessioni);

  // Costruttore
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

  // Metodo di utilita' che ritorna una stringa associata allo stato
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

  // Ritora l'ultima pagina del libro letta, calcolata facendo
  // la somma delle pagine lette in tutte le sessioni
  int getUltimaPagina() {
    return sessioni.fold(
        0, (int value, sessione) => value + sessione.pagineLette);
  }

  // Aggiunge una sessione di lettura al libro
  void aggiungiSessione(int pagine, Duration durata) async {
    // Crea una nuova sessione
    final sessione =
        Sessione(pagineLette: pagine, durata: durata.inMilliseconds);
    // la aggiunge alla `Box` delle sessioni
    await boxSessioni.add(sessione);
    // e infine alla lista delle sessioni del libro
    sessioni.add(sessione);
  }

  // Crea un `Libro` partendo da un json
  // utilizzato per creazione da API
  Libro.fromJson(Map<String, dynamic> json) {
    titolo = json["title"];
    autore = json["authors"].cast<String>()[0];
    pagine = json["pageCount"];
    isbn = json["industryIdentifiers"][1]["identifier"];
    copertina = json["imageLinks"]["thumbnail"];
    stato = Stato.daLeggere;
  }
}
