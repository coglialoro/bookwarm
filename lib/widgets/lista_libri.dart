import "package:bookwarm/modelli/libro.dart";
import "package:bookwarm/widgets/elemento_libro.dart";
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
        return ElementoLibro(libro: libri[index]);
      },
    );
  }
}
