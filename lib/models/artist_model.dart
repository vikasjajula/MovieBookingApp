import 'package:flutter/foundation.dart';

class Artist {
  final String id; // Assuming you're using ObjectId as String
  final String name;
  final String? alsoKnownAs;
  final List<String> occupation;
  final String born; // Change to String for consistency with the Movie class
  final String birthplace;
  final String about;
  final String? earlyLife;
  final String? actingCareer;
  final List<String>? awards;
  final String imageUrl;

  Artist({
    required this.id,
    required this.name,
    this.alsoKnownAs,
    required this.occupation,
    required this.born,
    required this.birthplace,
    required this.about,
    this.earlyLife,
    this.actingCareer,
    this.awards,
    required this.imageUrl,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['_id'],
      name: json['name'],
      alsoKnownAs: json['alsoKnownAs'],
      occupation: List<String>.from(json['occupation']),
      born: json['born'], // Keep as String
      birthplace: json['birthplace'],
      about: json['about'],
      earlyLife: json['earlyLife'],
      actingCareer: json['actingCareer'],
      awards: json['awards'] != null ? List<String>.from(json['awards']) : null,
      imageUrl: json['imageUrl'],
    );
  }

  // Convert the Artist object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'alsoKnownAs': alsoKnownAs,
      'occupation': occupation,
      'born': born,
      'birthplace': birthplace,
      'about': about,
      'earlyLife': earlyLife,
      'actingCareer': actingCareer,
      'awards': awards,
      'imageUrl': imageUrl,
    };
  }
}
