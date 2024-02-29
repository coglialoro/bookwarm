import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/widgets/lista_libri.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";

class Libreria extends StatelessWidget {
  const Libreria({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Libro>>(
      valueListenable: Hive.box<Libro>("libri").listenable(),
      builder: (context, box, _) {
        return Column(children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            child: Text(
              "Libreria",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Expanded(
            child: ListaLibri(libri: box.values.toList()),
          ),
        ]);
      },
    );
  }
}
