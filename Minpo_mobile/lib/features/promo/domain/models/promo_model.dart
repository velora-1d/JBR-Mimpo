import 'package:flutter/material.dart';

class PromoModel {
  final String id;
  final String title;
  final String description;
  final String price;
  final String? originalPrice;
  final String? timer;
  final bool isFlashSale;
  final Color color;
  final String imageUrl;

  PromoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.originalPrice,
    this.timer,
    this.isFlashSale = false,
    required this.color,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'timer': timer,
      'isFlashSale': isFlashSale,
      'color': color.toARGB32(),
      'imageUrl': imageUrl,
    };
  }

  factory PromoModel.fromJson(Map<String, dynamic> json) {
    return PromoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      originalPrice: json['originalPrice'] as String?,
      timer: json['timer'] as String?,
      isFlashSale: json['isFlashSale'] as bool? ?? false,
      color: Color(json['color'] as int),
      imageUrl: json['imageUrl'] as String,
    );
  }
}
