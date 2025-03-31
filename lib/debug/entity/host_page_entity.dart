import 'package:flutter/material.dart';

class HostPageEntity {
  final String? name;
  final int? id;
  final VoidCallback? func;
  final Color? backgroundColor;

  const HostPageEntity({this.name, this.func, this.id, this.backgroundColor});

  /// fromJson
  factory HostPageEntity.fromJson(dynamic json) => HostPageEntity(
        name: json['name'],
        func: json['func'],
        id: json['id'],
        backgroundColor: json['backgroundColor'],
      );

  /// toJson
  Map<String, dynamic> toJson() => {
        'name': name,
        'func': func,
        'id': id,
        'backgroundColor': backgroundColor,
      };
}
