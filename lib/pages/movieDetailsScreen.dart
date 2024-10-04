import 'package:flutter/material.dart';
import 'ArtistDetails.dart';
import '../models/movie_model.dart';
import '../models/artist_model.dart'; // Import your artist model
import '../services/movie_service.dart';
import './Theaters.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie; // Change to take Movie object directly

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> futureMovie; // This can be removed
  List<Artist> cast = [];
  List<Artist> crew = [];

  @override
  void initState() {
    super.initState();
    // Fetch artists using the movie object passed from the previous screen
    _fetchArtists(widget.movie.actors, widget.movie.crew);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Poster
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:
                    Image.network(widget.movie.bigposterUrl, fit: BoxFit.cover),
              ),
              SizedBox(height: 16),

              // Movie Title
              Text(
                widget.movie.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 8),

              // Movie Details (Genres, Duration, Certification)
              Text(
                'Genres: ${widget.movie.genres.join(", ")}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                'Duration: ${widget.movie.duration}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                'Certification: ${widget.movie.certificationRating}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),

              // Cast Section
              Text(
                'Cast',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildHorizontalCastCrewSection(cast),

              SizedBox(height: 16),

              // Crew Section
              Text(
                'Crew',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildHorizontalCastCrewSection(crew),

              SizedBox(height: 16),

              // Book Tickets Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the MovieBookingPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieBookingPage(
                            movieId: widget
                                .movie.id), // Replace with your actual page
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: Text(
                    'Book tickets',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Fetch artists for cast and crew
  void _fetchArtists(List<String> actorIds, List<String> crewIds) async {
    try {
      final castArtists = await MovieService().getArtistsByIds(actorIds);
      final crewArtists = await MovieService().getArtistsByIds(crewIds);
      setState(() {
        cast = castArtists;
        crew = crewArtists;
      });
    } catch (error) {
      print('Error fetching artists: $error');
    }
  }

  Widget _buildHorizontalCastCrewSection(List<Artist> data) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final artist = data[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the artist detail screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtistDetailScreen(artist: artist),
                ),
              );
            },
            child: Container(
              width: 120,
              margin: EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(artist.imageUrl),
                  ),
                  SizedBox(height: 8),
                  Text(
                    artist.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  // Uncomment if you have a role field in your Artist model
                  // Text(
                  //   artist.role,
                  //   style: TextStyle(fontSize: 12, color: Colors.grey),
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
