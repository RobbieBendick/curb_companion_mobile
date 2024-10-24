// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cc_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CCLocationAdapter extends TypeAdapter<CCLocation> {
  @override
  final int typeId = 1;

  @override
  CCLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CCLocation(
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      altitude: fields[2] as double?,
      accuracy: fields[3] as double?,
      address: fields[4] as CCAddress?,
    );
  }

  @override
  void write(BinaryWriter writer, CCLocation obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.altitude)
      ..writeByte(3)
      ..write(obj.accuracy)
      ..writeByte(4)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CCLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
