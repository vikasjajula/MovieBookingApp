import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: MovieBookingPage(movieId: '123'), // Example movieId
  ));
}

class MovieBookingPage extends StatefulWidget {
  final String movieId;

  MovieBookingPage({required this.movieId}); // Accept movieId as a parameter

  @override
  _MovieBookingPageState createState() => _MovieBookingPageState();
}

class _MovieBookingPageState extends State<MovieBookingPage> {
  List<String> dates = [];
  int selectedDateIndex = 0;
  Map<String, List<dynamic>> groupedTheaters = {};
  List<dynamic> currentTheaters = []; // The theaters for the selected date
  final String apiUrl = 'http://localhost:5000/show/getshows';

  @override
  void initState() {
    super.initState();
    fetchDates();
    fetchTheaterData(
      selectedDate: DateFormat('yyyy-MM-dd')
          .format(DateTime.now()), // Default fetch for today's date
    );
  }

  // Fetch dates
  Future<void> fetchDates() async {
    DateTime today = DateTime.now();
    List<String> fetchedDates = [];

    for (int i = 0; i <= 10; i++) {
      DateTime date = today.add(Duration(days: i));
      String formattedDate = DateFormat('EEE*dd*MMM').format(date);
      fetchedDates.add(formattedDate);
    }

    setState(() {
      dates = fetchedDates;
    });
  }

  // Fetch theater and showtime data from the backend based on the selected date
  Future<void> fetchTheaterData({required String selectedDate}) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'movieId': widget.movieId, // Use the movieId passed to the widget
          'date': selectedDate,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> fetchedTheaters = jsonDecode(response.body);
        print(fetchedTheaters);
        // Group theaters by date
        groupTheatersByDate(fetchedTheaters);
      } else {
        throw Exception('Failed to load theaters');
      }
    } catch (e) {
      print('Error fetching theater data: $e');
    }
  }

  // Group theaters by date and then group shows by theaters within that date
  void groupTheatersByDate(List<dynamic> theaters) {
    debugger();
    Map<String, Map<String, dynamic>> tempGroupedTheaters = {};

    for (var theater in theaters) {
      String dateKey = DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(theater['date'])); // Get formatted date
      String theaterId = theater['theaterId'];

      // Initialize the date key in the temp map if it doesn't exist
      if (!tempGroupedTheaters.containsKey(dateKey)) {
        tempGroupedTheaters[dateKey] = {};
      }

      // Initialize the theater in the temp map if it doesn't exist
      if (!tempGroupedTheaters[dateKey]!.containsKey(theaterId)) {
        tempGroupedTheaters[dateKey]![theaterId] = {
          'theaterName': theater['theaterName'],
          'theaterLocation': theater['theaterLocation'],
          'shows': [],
        };
      }

      // Add the show to the corresponding theater
      tempGroupedTheaters[dateKey]![theaterId]['shows'].add(theater);
    }

    print(tempGroupedTheaters);

// Sort shows by startTime and convert to a list
    for (var date in tempGroupedTheaters.keys) {
      for (var theater in tempGroupedTheaters[date]!.values) {
        theater['shows'].sort((a, b) {
          // Trim any whitespace from the startTime strings
          final startTimeA = a['startTime'].trim();
          final startTimeB = b['startTime'].trim();

          DateTime timeA;
          DateTime timeB;

          // Try parsing the start time and handle potential errors
          try {
            if (startTimeA.contains(':') && startTimeA.length <= 8) {
              // Handle AM/PM format
              timeA = DateFormat.jm().parseStrict(startTimeA);
            } else {
              // Handle ISO 8601 format
              timeA = DateTime.parse(startTimeA);
            }
          } catch (e) {
            print('Error parsing start time A: "$startTimeA" - Error: $e');
            timeA = DateTime.now(); // or set to some default time
          }

          try {
            if (startTimeB.contains(':') && startTimeB.length <= 8) {
              // Handle AM/PM format
              timeB = DateFormat.jm().parseStrict(startTimeB);
            } else {
              // Handle ISO 8601 format
              timeB = DateTime.parse(startTimeB);
            }
          } catch (e) {
            print('Error parsing start time B: "$startTimeB" - Error: $e');
            timeB = DateTime.now(); // or set to some default time
          }

          return timeA.compareTo(timeB);
        });
      }
    }

    // Convert the nested map structure to a list of theaters
    Map<String, List<dynamic>> groupedTheaterList = {};
    for (var date in tempGroupedTheaters.keys) {
      groupedTheaterList[date] = tempGroupedTheaters[date]!.values.toList();
    }

    // Set the state
    setState(() {
      groupedTheaters = groupedTheaterList;
      currentTheaters = groupedTheaterList.isNotEmpty
          ? groupedTheaterList.keys.elementAt(selectedDateIndex).isNotEmpty
              ? groupedTheaterList[
                  groupedTheaterList.keys.elementAt(selectedDateIndex)]!
              : []
          : [];
    });
  }

  // Update selected date and fetch the data accordingly
  void handleDateSelection(int index) {
    setState(() {
      selectedDateIndex = index;
    });

    String selectedDate = DateFormat('yyyy-MM-dd').format(
      DateTime.now().add(Duration(days: index)),
    );

    fetchTheaterData(
        selectedDate: selectedDate); // Fetch showtimes for the selected date
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Ticket Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Movie Title (Telugu)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Date Selection UI
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: selectedDateIndex > 0
                      ? () {
                          handleDateSelection(selectedDateIndex - 1);
                        }
                      : null,
                ),
                Expanded(
                  child: dates.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            int visibleIndex = selectedDateIndex + index;
                            if (visibleIndex < dates.length) {
                              return GestureDetector(
                                onTap: () {
                                  handleDateSelection(visibleIndex);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: visibleIndex == selectedDateIndex
                                        ? Colors.blueAccent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(dates[visibleIndex].split('*')[0],
                                          style: TextStyle(
                                              color: visibleIndex ==
                                                      selectedDateIndex
                                                  ? Colors.white
                                                  : Colors.black)),
                                      Text(dates[visibleIndex].split('*')[1],
                                          style: TextStyle(
                                              color: visibleIndex ==
                                                      selectedDateIndex
                                                  ? Colors.white
                                                  : Colors.black)),
                                      Text(dates[visibleIndex].split('*')[2],
                                          style: TextStyle(
                                              color: visibleIndex ==
                                                      selectedDateIndex
                                                  ? Colors.white
                                                  : Colors.black)),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          }))
                      : Center(child: CircularProgressIndicator()),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: selectedDateIndex + 4 < dates.length
                      ? () {
                          handleDateSelection(selectedDateIndex + 1);
                        }
                      : null,
                ),
              ],
            ),
            Divider(height: 32),

            // Theater and showtimes list
            Expanded(
              child: currentTheaters.isNotEmpty
                  ? ListView.builder(
                      itemCount: currentTheaters.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentTheaters[index]['theaterName'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(currentTheaters[index]['theaterLocation']),
                                SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: currentTheaters[index]['shows']
                                      .map<Widget>((show) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(show['startTime']),
                                          Text(show['screenType']),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
