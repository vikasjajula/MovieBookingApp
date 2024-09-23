class Movie {
  final String id;
  final String title;
  final String description;
  final List<String> genres;
  final String releaseDate;
  final String posterUrl;
  final String bigposterUrl;
  final String duration;
  final String certificationRating;
  final List<String> displayFormats;
  final bool featured;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.genres,
    required this.releaseDate,
    required this.posterUrl,
    required this.bigposterUrl,
    required this.duration,
    required this.certificationRating,
    required this.displayFormats,
    required this.featured,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      genres: List<String>.from(json['genres']),
      releaseDate: json['releaseDate'],
      posterUrl: json['posterUrl'],
      bigposterUrl: json['bigposterUrl'],
      duration: json['duration'],
      certificationRating: json['certificationRating'],
      displayFormats: List<String>.from(json['displayFormats']),
      featured: json['featured'] ?? false,
    );
  }
}
