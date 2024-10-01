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
  final List<String> actors; // Assuming these are ObjectIds as Strings
  final List<String> crew; // Assuming these are ObjectIds as Strings
  final List<String> theaters; // Assuming these are ObjectIds as Strings
  final List<String> bookings; // Assuming these are ObjectIds as Strings
  final String admin; // Assuming this is an ObjectId as String

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
    required this.actors,
    required this.crew,
    required this.theaters,
    required this.bookings,
    required this.admin,
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
      actors: List<String>.from(json['actors']), // Added actors
      crew: List<String>.from(json['crew']), // Added crew
      theaters: List<String>.from(json['theaters']), // Added theaters
      bookings: List<String>.from(json['bookings']), // Added bookings
      admin: json['admin'], // Added admin
    );
  }
}
