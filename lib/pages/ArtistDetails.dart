import 'package:flutter/material.dart';
import '../models/artist_model.dart';

class ArtistDetailScreen extends StatefulWidget {
  final Artist artist;

  ArtistDetailScreen({required this.artist});

  @override
  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artist.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Added scroll functionality for long content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
            children: [
              // Artist Profile Image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.artist.imageUrl),
              ),
              SizedBox(height: 16),

              // Artist Name
              Text(
                widget.artist.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),

              // Artist Details
              if (widget.artist.alsoKnownAs != null &&
                  widget.artist.alsoKnownAs!.isNotEmpty)
                Text(
                  'Also Known As: ${widget.artist.alsoKnownAs}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              SizedBox(height: 8),

              if (widget.artist.occupation.isNotEmpty)
                Text(
                  'Occupation: ${widget.artist.occupation.join(', ')}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              SizedBox(height: 8),

              if (widget.artist.born.isNotEmpty)
                Text(
                  'Date of Birth: ${widget.artist.born}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              SizedBox(height: 8),

              if (widget.artist.birthplace.isNotEmpty)
                Text(
                  'Birthplace: ${widget.artist.birthplace}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              SizedBox(height: 16),

              // About Section
              Text(
                'About',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.artist.about.isNotEmpty
                    ? widget.artist.about
                    : 'No details available',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),

              // Early Life Section
              if (widget.artist.earlyLife != null &&
                  widget.artist.earlyLife!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Early Life',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.artist.earlyLife!,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              SizedBox(height: 16),

              // Acting Career Section
              if (widget.artist.actingCareer != null &&
                  widget.artist.actingCareer!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acting Career',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.artist.actingCareer!,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              SizedBox(height: 16),

              // Awards Section
              if (widget.artist.awards != null &&
                  widget.artist.awards!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Awards',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.artist.awards!.join(', '),
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
