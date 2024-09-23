import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_model.dart'; // Make sure this corresponds to the Flutter movie model

class MovieService {
  static const String baseUrl =
      "http://192.168.0.208:5000/"; // Ensure the trailing slash for the URL

  Future<List<Movie>> getAllMovies() async {
    final response = await http.get(Uri.parse("${baseUrl}movie"));

    if (response.statusCode == 200) {
      List jsonResponse =
          json.decode(response.body)['movies']; // Access the 'movies' field
      return jsonResponse.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
