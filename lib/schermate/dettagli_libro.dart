import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/schermate/gestione_sessione.dart";
import "package:flutter/material.dart";

class DettagliLibro extends StatelessWidget {
  final Libro libro;

  const DettagliLibro({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dettagli libro"),
      ),
      body: Column(
        children: [
          if (libro.copertina != null && libro.copertina != "") ...[
            Image.network(libro.copertina!),
          ],
          Text(libro.titolo),
          Text(libro.autore),
          Text(libro.casaEditice ?? ""),
          Text(libro.descrizione ?? ""),
          Text(libro.isbn),
          Text("${libro.pagine}"),
          Text(libro.getStatoString()),
          if (libro.stato == Stato.daLeggere ||
              libro.stato == Stato.finito) ...[
            ElevatedButton(
              child: const Text("Inizia a leggere"),
              onPressed: () {
                libro.stato = Stato.inLettura;
                libro.save();
                // final libri = Hive.box<Libro>("libri");

                // libri.put(libro.isbn, libro.copyWith(stato: Stato.inLettura));
                Navigator.pop(context);
              },
            )
          ],
          if (libro.stato == Stato.daLeggere ||
              libro.stato == Stato.inLettura) ...[
            ElevatedButton(
              child: const Text("Finito"),
              onPressed: () {
                libro.stato = Stato.finito;
                libro.save();
                // final libri = Hive.box<Libro>("libri");
                // libri.put(libro.isbn, libro.copyWith(stato: Stato.finito));
                Navigator.pop(context);
              },
            )
          ],
          ElevatedButton(
            child: const Text("Elimina"),
            onPressed: () {
              libro.delete();
              // final libri = Hive.box<Libro>("libri");
              // libri.delete(libro.isbn);
              Navigator.pop(context);
            },
          ),
          if (libro.stato == Stato.inLettura) ...[
            const Text("Sessioni"),
            ...libro.sessioni
                .map(
                  (sessione) => Text(
                      "Tempo: ${Duration(milliseconds: sessione.durata).toString()}, Pagine:${sessione.pagineLette}"),
                )
                .toList(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GestioneSessione(libro: libro),
                    ),
                  );
                },
                child: const Text("Inizia sessione"))
          ]
        ],
      ),
    );
  }
}
