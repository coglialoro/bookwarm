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
  final formKey = GlobalKey<FormState>();

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
  void dispose() {
    controllerPaginaIniziale.dispose();
    controllerPaginaFinale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fine sessione"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const Text(
              "Pagina iniziale",
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              controller: controllerPaginaIniziale,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Inserisci pagina iniziale";
                }
                if (int.parse(value) < 0) {
                  return "Inserisci un numero positivo";
                }
                return null;
              },
            ),
            const Text(
              "Pagina finale",
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              controller: controllerPaginaFinale,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Inserisci pagina finale";
                }
                if (int.parse(value) <
                    int.parse(controllerPaginaIniziale.value.text)) {
                  return "La pagina finale deve essere dopo quella iniziale";
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final pagineLette =
                      int.parse(controllerPaginaFinale.value.text) -
                          int.parse(controllerPaginaIniziale.value.text);
                  widget.libro.aggiungiSessione(pagineLette, widget.durata);
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                }
              },
              child: const Text("Salva"),
            ),
          ],
        ),
      ),
    );
  }
}
