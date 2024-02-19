// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessione.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessioneAdapter extends TypeAdapter<Sessione> {
  @override
  final int typeId = 1;

  @override
  Sessione read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sessione(
      pagineLette: fields[0] as int,
      inizio: fields[1] as DateTime,
      fine: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Sessione obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.pagineLette)
      ..writeByte(1)
      ..write(obj.inizio)
      ..writeByte(2)
      ..write(obj.fine);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessioneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
