import 'package:curb_companion/features/recent_search/domain/recent_search.dart';
import 'package:hive/hive.dart';

class RecentSearchItemAdapter extends TypeAdapter<SearchItem> {
  @override
  int get typeId => 3;

  @override
  SearchItem read(BinaryReader reader) {
    return SearchItem(
      reader.readString(),
      DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, SearchItem obj) {
    writer.writeString(obj.query);
    writer.writeString(obj.timestamp.toIso8601String());
  }
}
