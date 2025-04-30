class ToStringBuilder {
  ToStringBuilder({this.type});

  final Type? type;
  final Map<String, dynamic> properties = <String, dynamic>{};

  ToStringBuilder addProperty(String name, dynamic value) {
    properties[name] = value;
    return this;
  }

  @override
  String toString() {
    final StringBuffer buffer = StringBuffer(type ?? '')..write('\u0020{');
    if (properties.isNotEmpty) {
      buffer.writeln();
      for (final MapEntry<String, dynamic> property in properties.entries) {
        buffer
          ..write('\t"')
          ..write(property.key)
          ..write('":\u0020"')
          ..write(property.value)
          ..writeln('",');
      }
    }

    buffer.write('}');
    return buffer.toString();
  }
}
