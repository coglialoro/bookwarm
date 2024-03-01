import "package:bookwarm/modelli/libro.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hive_flutter/hive_flutter.dart";

class AggiungiLibroManuale extends StatefulWidget {
  const AggiungiLibroManuale({super.key});

  @override
  State<AggiungiLibroManuale> createState() => _AggiungiLibroManualeState();
}

class _AggiungiLibroManualeState extends State<AggiungiLibroManuale> {
  // Chiave globale per gestire lo stato della form
  final formKey = GlobalKey<FormState>();

  // Controllers per i campi della form
  late TextEditingController controllerTitolo;
  late TextEditingController controllerAutore;
  late TextEditingController controllerCasaEditrice;
  late TextEditingController controllerPagine;
  late TextEditingController controllerIsbn;
  late TextEditingController controllerDescrizione;

  late Box<Libro> libri;

  @override
  void initState() {
    super.initState();

    // Inizializzazione controllers
    controllerTitolo = TextEditingController();
    controllerAutore = TextEditingController();
    controllerCasaEditrice = TextEditingController();
    controllerPagine = TextEditingController();
    controllerIsbn = TextEditingController();
    controllerDescrizione = TextEditingController();

    // Apriamo la box
    libri = Hive.box("libri");
  }

  @override
  void dispose() {
    // Liberiamo le risorse
    controllerTitolo.dispose();
    controllerAutore.dispose();
    controllerCasaEditrice.dispose();
    controllerPagine.dispose();
    controllerIsbn.dispose();
    controllerDescrizione.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aggiungi libro"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // Associamo il controller al campo
                controller: controllerTitolo,
                // Mostriamo il suggerimento per ogni campo
                decoration: const InputDecoration(hintText: "Titolo"),
                // Validazione
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Inserisci un titolo";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerAutore,
                decoration: const InputDecoration(hintText: "Autore"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Inserisci un autore";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerCasaEditrice,
                decoration: const InputDecoration(hintText: "Casa Editrice"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerPagine,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: "Pagine"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Inserisci numero pagine";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerIsbn,
                maxLength: 13,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: "ISBN"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Inserisci ISBN";
                  }
                  if (value.length < 13) {
                    return "ISBN deve avere 13 caratteri";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerDescrizione,
                decoration: const InputDecoration(hintText: "Descrizione"),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    // Controlliamo se l'attuale stato della form e' valido
                    if (formKey.currentState!.validate()) {
                      // Instanziamo un nuovo libro
                      final libro = Libro(
                        titolo: controllerTitolo.value.text,
                        autore: controllerAutore.value.text,
                        pagine: int.parse(controllerPagine.value.text),
                        isbn: controllerIsbn.value.text,
                        casaEditice: controllerCasaEditrice.value.text,
                        descrizione: controllerDescrizione.value.text,
                      );

                      // e lo inseriamo nella `Box`
                      libri.add(libro);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Aggiungi")),
            )
          ],
        ),
      ),
    );
  }
}
