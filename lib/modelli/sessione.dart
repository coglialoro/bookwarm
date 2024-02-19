import "package:hive/hive.dart";

part "sessione.g.dart";

@HiveType(typeId: 1)
class Sessione {
  @HiveField(0)
  final int pagineLette;
  @HiveField(1)
  final DateTime inizio;
  @HiveField(2)
  final DateTime fine;

  Sessione({
    required this.pagineLette,
    required this.inizio,
    required this.fine,
  });
}
