import 'package:hive/hive.dart';
part 'name_config.g.dart';

@HiveType(typeId: 1)
class NameConfig extends HiveObject{

  @HiveField(0)
  List<String> names;

  @HiveField(1)
  List<String> ips;

  @HiveField(2)
  String zaehlerIP;

  @HiveField(3)
  String pvIP;

  NameConfig({
    required this.names,
    required this.ips,
    required this.zaehlerIP,
    required this.pvIP
  });

}