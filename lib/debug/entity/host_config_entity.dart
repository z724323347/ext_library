// import 'package:json_annotation/json_annotation.dart';

class HostConfigEntity {
  String? name;
  String? host;

  HostConfigEntity({this.name, this.host});

  /// fromJson [Map/dynamic]
  factory HostConfigEntity.fromJson(Map json) =>
      HostConfigEntity(name: json['name'], host: json['host']);

  /// toJson
  Map<String, dynamic> toJson() => {'name': name, 'host': host};
}
