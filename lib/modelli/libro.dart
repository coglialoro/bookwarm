class Libro {
  String titolo;
  String autore;
  int pagine;
  String? casaEditice;
  String isbn;
  String? descrizione;
  String? copertina;

  Libro(
      {required this.titolo,
      required this.autore,
      required this.pagine,
      this.casaEditice,
      required this.isbn,
      this.descrizione,
      this.copertina});
}
