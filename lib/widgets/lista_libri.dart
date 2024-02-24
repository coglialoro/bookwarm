import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/schermate/dettagli_libro.dart";
import "package:flutter/material.dart";

class ListaLibri extends StatelessWidget {
  final List<Libro> libri;

  const ListaLibri({
    super.key,
    required this.libri,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: libri.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(libri[index].titolo),
          subtitle: Text(libri[index].autore),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DettagliLibro(libro: libri[index]),
              ),
            );
          },
        );
      },
    );
  }
}
