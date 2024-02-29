import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/schermate/dettagli_libro.dart";
import "package:flutter/material.dart";

class ElementoLibro extends StatelessWidget {
  final Libro libro;
  const ElementoLibro({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          libro.titolo,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Text(libro.autore),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        tileColor: Colors.blue[100],
        leading: (libro.copertina != null && libro.copertina != "")
            ? Image.network(
                libro.copertina!,
              )
            : const Placeholder(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DettagliLibro(libro: libro),
            ),
          );
        },
      ),
    );
  }
}
