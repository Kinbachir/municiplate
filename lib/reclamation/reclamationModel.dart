import 'package:flutter/foundation.dart';

@immutable
class Reclamation {
  Reclamation({this.type, this.gps, this.note, this.image, this.user});

  Reclamation.fromJson(Map<String, Object?> json)
      : this(
            type: json['type'] as String,
            gps: json['gps'] as String,
            note: json['note']! as String,
            image: json['image']! as String,
            user: json['user'] as String);

  String? note;

  String? gps;

  String? image;

  String? type;

  String? user;

  Map<String, Object?> toJson() {
    return {
      'type': type,
      'gps': gps,
      'note': note,
      'image': image,
      'user': user,
    };
  }

  @override
  String toString() {
    return "{\"type\":\"" +
        type! +
        "\",\"note\":\"" +
        this.note! +
        "\",\"image\":\"" +
        this.image! +
        "\",\"gps\":\"" +
        this.gps! +
        "\"}";
  }
}
