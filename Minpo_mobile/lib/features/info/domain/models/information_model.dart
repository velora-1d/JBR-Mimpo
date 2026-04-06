import 'package:flutter/material.dart';

class InformationModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? date;
  final String? time;
  final String? status;
  final String? updateTime;
  final bool isPinned;
  final int iconCodePoint;
  final String iconFontFamily;
  final Color color;

  InformationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.date,
    this.time,
    this.status,
    this.updateTime,
    this.isPinned = false,
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date,
      'time': time,
      'status': status,
      'updateTime': updateTime,
      'isPinned': isPinned,
      'iconCodePoint': iconCodePoint,
      'iconFontFamily': iconFontFamily,
      'color': color.toARGB32(),
    };
  }

  factory InformationModel.fromJson(Map<String, dynamic> json) {
    return InformationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      date: json['date'] as String?,
      time: json['time'] as String?,
      status: json['status'] as String?,
      updateTime: json['updateTime'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
      iconCodePoint: json['iconCodePoint'] as int,
      iconFontFamily: json['iconFontFamily'] as String,
      color: Color(json['color'] as int),
    );
  }

  IconData get icon => IconData(iconCodePoint, fontFamily: iconFontFamily);
}
