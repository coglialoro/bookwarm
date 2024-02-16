import 'package:bookwarm/modelli/libro.dart';
import 'package:bookwarm/modelli/sessione.dart';

class Progresso {
  final Libro libro;
  List<Sessione> sessioni = [];

  Progresso({required this.libro});
}
