import "package:hive/hive.dart";

part "sessione.g.dart";

@HiveType(typeId: 1)
class Sessione extends HiveObject {
  @HiveField(0)
  final int pagineLette;
  @HiveField(1)
  final int durata;

  Sessione({
    required this.pagineLette,
    required this.durata,
  });
}
