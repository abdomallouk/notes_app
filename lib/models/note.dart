import 'package:isar/isar.dart';

// this line is needed to generate the Isar collection
// then run this : dart run build_runner build
part "note.g.dart";

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String text;
}
