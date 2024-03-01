import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/widgets/lista_libri.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Questo widget ci permette di mostrare i valori dei libri nella `Box`
    // quando questi si aggiornano
    return ValueListenableBuilder<Box<Libro>>(
      valueListenable: Hive.box<Libro>("libri").listenable(),
      builder: (context, box, _) {
        // Filtriamo i libri da `inLettura`
        final daLeggere = box.values
            .where((element) => element.stato == Stato.inLettura)
            .toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: Row(
                children: [
                  const Text(
                    "In lettura  ",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Badge(
                    backgroundColor: Colors.grey[400],
                    label: Text(
                      "${daLeggere.length}",
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListaLibri(libri: daLeggere),
            ),
          ],
        );
      },
    );
  }
}
