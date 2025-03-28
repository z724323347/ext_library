import 'package:flutter/material.dart';

class HostPageEntity {
  final String? name;
  final int? id;
  final VoidCallback? func;

  const HostPageEntity({this.name, this.func, this.id});

  /// fromJson
  factory HostPageEntity.fromJson(dynamic json) => HostPageEntity(
        name: json['name'],
        func: json['func'],
        id: json['id'],
      );

  /// toJson
  Map<String, dynamic> toJson() => {
        'name': name,
        'func': func,
        'id': id,
      };
}
