import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../models/artist_model.dart'; // Import your artist model
import '../services/movie_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Movie>> movies;
  final MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    // Fetching movies from backend
    movies = _movieService.getAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "It All Starts Here",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text("Nizamabad",
                    style: TextStyle(fontSize: 16, color: Colors.red)),
                Icon(Icons.arrow_drop_down, color: Colors.red),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: Icon(Icons.qr_code), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Movies Found'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recommended Movies Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Recommended Movies",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(onPressed: () {}, child: Text("See All")),
                    ],
                  ),
                ),
                // Horizontal List of Movies
                Container(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Movie movie = snapshot.data![index];
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                          child: MovieCard(
                            title: movie.title,
                            rating: movie.certificationRating,
                            votes:
                                "N/A", // Add votes if you have that in the backend
                            imageUrl: movie.posterUrl,
                          ));
                    },
                  ),
                ),
                // Other UI Sections
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.pink[50],
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red),
                          SizedBox(width: 10),
                          Text("See what's playing in cinemas near you",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: Colors.red[100],
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("FREE MOVIE TICKETS with Credit Cards",
                              style: TextStyle(fontSize: 16)),
                          ElevatedButton(
                              onPressed: () {}, child: Text("Apply Now")),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), label: 'Live Events'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final String rating;
  final String votes;
  final String imageUrl;

  MovieCard({
    required this.title,
    required this.rating,
    required this.votes,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageUrl, height: 180, width: 150, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow, size: 16),
              SizedBox(width: 4),
              Text(rating, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Text("($votes votes)", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

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
                    // Action for booking tickets
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
              ),
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

  // Widget to build horizontally scrollable Cast and Crew sections
  Widget _buildHorizontalCastCrewSection(List<Artist> data) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final artist = data[index];
          return Container(
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
                // Text(
                //   artist.role, // Assuming you have a role field in Artist model
                //   style: TextStyle(fontSize: 12, color: Colors.grey),
                //   textAlign: TextAlign.center,
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
