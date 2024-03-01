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
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        children: [
          if (libro.copertina != null && libro.copertina != "") ...[
            Image.network(
              libro.copertina!,
              height: 128,
              width: 128,
            ),
          ],
          Center(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                libro.titolo,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                libro.autore,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Casa editrice: "),
              Text(libro.casaEditice ?? "Non disponibile"),
            ],
          ),
          const Text("Descrizione:"),
          Text(libro.descrizione ?? "Non disponibile"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("ISBN: "),
              Text(libro.isbn),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Pagine: "),
              Text("${libro.pagine}"),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Stato: "),
              Text(libro.getStatoString()),
            ],
          ),
          // Mostriamo i pulsanti per leggere i libri solo negli stati corretti
          if (libro.stato == Stato.daLeggere ||
              libro.stato == Stato.finito) ...[
            ElevatedButton(
              child: const Text("Inizia a leggere"),
              onPressed: () {
                libro.stato = Stato.inLettura;
                libro.save();
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
                Navigator.pop(context);
              },
            )
          ],
          if (libro.stato == Stato.inLettura ||
              libro.stato == Stato.finito) ...[
            const Text("Sessioni"),
            ...libro.sessioni.map((sessione) {
              final durata = Duration(milliseconds: sessione.durata);
              final ore = durata.inHours;
              final minuti = durata.inMinutes - ore * 60;
              final secondi = durata.inSeconds - ore * 3600 - minuti * 60;
              return Text(
                  "Tempo: ${ore > 0 ? "$ore ore, " : ""} ${minuti > 0 ? "$minuti minuti ," : ""}$secondi secondi, Pagine:${sessione.pagineLette}");
            }).toList(),
          ],
          if (libro.stato == Stato.inLettura) ...[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GestioneSessione(libro: libro),
                  ),
                );
              },
              child: const Text("Inizia sessione"),
            ),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.delete),
        onPressed: () {
          for (final session in libro.sessioni) {
            session.delete();
          }
          libro.delete();
          Navigator.pop(context);
        },
      ),
    );
  }
}
