// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cc_address.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CCAddressAdapter extends TypeAdapter<CCAddress> {
  @override
  final int typeId = 0;

  @override
  CCAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CCAddress(
      street: fields[0] as String?,
      city: fields[1] as String?,
      state: fields[2] as String?,
      country: fields[3] as String?,
      postalCode: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CCAddress obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.street)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.country)
      ..writeByte(4)
      ..write(obj.postalCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CCAddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
