import "package:bookwarm/modelli/libro.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";

class Libreria extends StatelessWidget {
  const Libreria({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Libro>>(
      valueListenable: Hive.box<Libro>("libri").listenable(),
      builder: (context, box, _) {
        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(box.getAt(index)!.titolo),
              subtitle: Text(box.get(index)!.autore),
            );
          },
        );
      },
    );
  }
}
