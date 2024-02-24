// GENERATED CODE - DO NOT MODIFY BY HAND

part of "libro.dart";

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LibroAdapter extends TypeAdapter<Libro> {
  @override
  final int typeId = 0;

  @override
  Libro read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Libro(
      titolo: fields[0] as String,
      autore: fields[1] as String,
      pagine: fields[2] as int,
      casaEditice: fields[3] as String?,
      isbn: fields[4] as String,
      descrizione: fields[5] as String?,
      copertina: fields[6] as String?,
      stato: fields[7] as Stato,
    )..sessioni = (fields[8] as HiveList).castHiveList();
  }

  @override
  void write(BinaryWriter writer, Libro obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.titolo)
      ..writeByte(1)
      ..write(obj.autore)
      ..writeByte(2)
      ..write(obj.pagine)
      ..writeByte(3)
      ..write(obj.casaEditice)
      ..writeByte(4)
      ..write(obj.isbn)
      ..writeByte(5)
      ..write(obj.descrizione)
      ..writeByte(6)
      ..write(obj.copertina)
      ..writeByte(7)
      ..write(obj.stato)
      ..writeByte(8)
      ..write(obj.sessioni);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LibroAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatoAdapter extends TypeAdapter<Stato> {
  @override
  final int typeId = 2;

  @override
  Stato read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Stato.daLeggere;
      case 1:
        return Stato.inLettura;
      case 2:
        return Stato.finito;
      default:
        return Stato.daLeggere;
    }
  }

  @override
  void write(BinaryWriter writer, Stato obj) {
    switch (obj) {
      case Stato.daLeggere:
        writer.writeByte(0);
        break;
      case Stato.inLettura:
        writer.writeByte(1);
        break;
      case Stato.finito:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
