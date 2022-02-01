import 'package:hive/hive.dart';

class HiveDurationAdapter extends TypeAdapter<Duration> {
  final int typeId = 16; // or whatever free id you have

  Duration read(BinaryReader reader) {
    return Duration(seconds: reader.read());
  }

  void write(BinaryWriter writer, Duration obj) {
    writer.write(obj.inSeconds);
  }
}
