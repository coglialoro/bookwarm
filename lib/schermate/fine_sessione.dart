import "package:bookwarm/modelli/libro.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class FineSessione extends StatefulWidget {
  final Libro libro;
  final Duration durata;

  const FineSessione({super.key, required this.libro, required this.durata});

  @override
  State<FineSessione> createState() => _FineSessioneState();
}

class _FineSessioneState extends State<FineSessione> {
  late TextEditingController controllerPaginaIniziale;
  late TextEditingController controllerPaginaFinale;

  @override
  void initState() {
    super.initState();

    controllerPaginaIniziale = TextEditingController(
      text: "${widget.libro.getUltimaPagina()}",
    );
    controllerPaginaFinale = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fine sessione"),
      ),
      body: Column(
        children: [
          const Text("Pagina Iniziale:"),
          TextField(
            controller: controllerPaginaIniziale,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const Text("Pagina finale:"),
          TextField(
            controller: controllerPaginaFinale,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          ElevatedButton(
            onPressed: () async {
              // final libri = Hive.box<Libro>("libri");
              final pagineLette = int.parse(controllerPaginaFinale.value.text) -
                  int.parse(controllerPaginaIniziale.value.text);
              widget.libro.aggiungiSessione(pagineLette, widget.durata);
              widget.libro.save();
              // libri.put(
              //   widget.libro.isbn,
              //   widget.libro,
              // );
              Navigator.pop(context);
            },
            child: const Text("Salva"),
          ),
        ],
      ),
    );
  }
}
