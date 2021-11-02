import 'package:flutter/foundation.dart';

@immutable
class news {
  news({
    this.title,
    this.date,
    this.note,
    this.image,
  });

  news.fromJson(Map<String, Object?> json)
      : this(
          title: json['title'] as String,
          date: json['date'] as String,
          note: json['note'] as String,
          image: json['image'] as String,
        );

  String? note;
  String? date;
  String? image;
  String? title;

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'date': date,
      'note': note,
      'image': image,
    };
  }

  @override
  String toString() {
    return "{\"title\":\"" +
        title! +
        "\",\"note\":\"" +
        this.note! +
        "\",\"image\":\"" +
        this.image! +
        "\",\"date\":\"" +
        this.date! +
        "\"}";
  }
}
