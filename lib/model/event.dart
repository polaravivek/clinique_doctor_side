import 'dart:convert';

import 'package:flutter/material.dart';

class Event {
  final String? id;
  final String title;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  Event({
    this.id,
    required this.title,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.lightGreen,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'from': from.millisecondsSinceEpoch,
      'to': to.millisecondsSinceEpoch,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      from: DateTime.fromMillisecondsSinceEpoch(map['from']),
      to: DateTime.fromMillisecondsSinceEpoch(map['to']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}
