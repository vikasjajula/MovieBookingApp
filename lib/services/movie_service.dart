import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart'; // Make sure this corresponds to the Flutter movie model
import '../models/artist_model.dart';

class MovieService {
  static const String baseUrl = "http://localhost:5000/";

  var localStorage; // Ensure the trailing slash for the URL

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

  Future<List<Artist>> getArtistsByIds(List<String> ids) async {
    final response = await http.post(
      Uri.parse('${baseUrl}artist/getByIds'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${""}', // If you're using localStorage
      },
      body: jsonEncode({'ids': ids}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> artistData = jsonDecode(response.body)['artists'];
      return artistData.map((artist) => Artist.fromJson(artist)).toList();
    } else {
      throw Exception('Failed to load artists');
    }
  }
}
