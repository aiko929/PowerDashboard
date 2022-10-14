// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'name_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NameConfigAdapter extends TypeAdapter<NameConfig> {
  @override
  final int typeId = 1;

  @override
  NameConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NameConfig(
      names: (fields[0] as List).cast<String>(),
      ips: (fields[1] as List).cast<String>(),
      zaehlerIP: fields[2] as String,
      pvIP: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NameConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.names)
      ..writeByte(1)
      ..write(obj.ips)
      ..writeByte(2)
      ..write(obj.zaehlerIP)
      ..writeByte(3)
      ..write(obj.pvIP);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
