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
  final controllerTitolo = TextEditingController();
  final controllerAutore = TextEditingController();
  final controllerCasaEditrice = TextEditingController();
  final controllerPagine = TextEditingController();
  final controllerIsbn = TextEditingController();
  final controllerDescrizione = TextEditingController();

  late Box<Libro> libri;

  @override
  void initState() {
    super.initState();
    libri = Hive.box("libri");
  }

  @override
  void dispose() {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const Text("Titolo"),
          TextField(
            controller: controllerTitolo,
          ),
          const Text("Autore"),
          TextField(
            controller: controllerAutore,
          ),
          const Text("Casa Editrice"),
          TextField(
            controller: controllerCasaEditrice,
          ),
          const Text("Pagine"),
          TextField(
            controller: controllerPagine,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const Text("ISBN"),
          TextField(
            controller: controllerIsbn,
          ),
          const Text("Descrizione"),
          TextField(
            controller: controllerDescrizione,
          ),
          const Padding(padding: EdgeInsets.all(8)),
          ElevatedButton(
              onPressed: () async {
                final libro = Libro(
                  titolo: controllerTitolo.value.text,
                  autore: controllerAutore.value.text,
                  pagine: int.parse(controllerPagine.value.text),
                  isbn: controllerIsbn.value.text,
                  casaEditice: controllerCasaEditrice.value.text,
                  descrizione: controllerDescrizione.value.text,
                );
                //libri.put(controllerIsbn.value.text, libro);
                libri.add(libro);
                Navigator.pop(context);
              },
              child: const Text("Aggiungi"))
        ],
      ),
    );
  }
}
