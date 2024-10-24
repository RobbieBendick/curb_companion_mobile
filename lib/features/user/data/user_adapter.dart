import 'package:curb_companion/features/user/domain/user.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:hive/hive.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  int get typeId => 4;

  @override
  User read(BinaryReader reader) {
    return User(
      id: reader.readString(),
      email: reader.readString(),
      firstName: reader.readString(),
      surname: reader.readString(),
      location: reader.read() as CCLocation?,
      dateOfBirth: reader.read() as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.id as String);
    writer.writeString(obj.email as String);
    writer.writeString(obj.firstName as String);
    writer.writeString(obj.surname as String);
    writer.write(obj.location);
    writer.write(obj.dateOfBirth);
  }
}
