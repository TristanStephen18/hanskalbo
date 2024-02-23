import 'package:hive/hive.dart';

part 'data.g.dart';

@HiveType(typeId: 1)
class Data{
  @HiveField(0)
  String name;

  Data({
    required this.name
  });
}