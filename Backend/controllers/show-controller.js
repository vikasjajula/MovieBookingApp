import jwt from "jsonwebtoken";
import mongoose from "mongoose";
import Screen from "../models/Screen";
import Theater  from "../models/Theater";
import Movie from "../models/Movie";
import Show from "../models/Show";

export const AddShow = async (req, res) => {
  try {
    const { movieId, theaterId, screenId, date, startTime, endTime, standardPrice } = req.body;
    console.log(req.body);
    // Check if all required fields are provided
    if (!movieId || !theaterId || !screenId || !date || startTime === undefined || endTime === undefined || standardPrice === undefined) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    // Check if the movie, theater, and screen exist in the database
    const theater = await Theater.findById(theaterId);
    const movie = await Movie.findById(movieId);
    const screen = await Screen.findById(screenId);
    
    if (!theater) {
      return res.status(404).json({ message: 'Theater not found' });
    }
    if (!movie) {
      return res.status(404).json({ message: 'Movie not found' });
    }
    if (!screen) {
      return res.status(404).json({ message: 'Screen not found' });
    }

    // Create new Show, not Screen
    const newShow = new Show({
      movieId,
      theaterId,
      screenId,
      date,
      startTime,
      endTime,
      standardPrice
    });

    const savedShow = await newShow.save();
    res.status(201).json(savedShow);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

export const getShows = async (req, res) => {
  try {
    const { movieId, date } = req.body; // Get movieId and date from request body

    // Format the date to ensure proper comparison, assuming the backend date format is 'YYYY-MM-DD'
    const formattedDate = new Date(date).toISOString().split('T')[0]; // Convert date to 'YYYY-MM-DD'

    let filter = { date: { $gte: formattedDate } }; // Filter for shows on or after the specified date

    // If movieId is provided, add it to the filter
    if (movieId) {
      filter.movieId = movieId;
    }

    // Fetch shows based on the filter
    const shows = await Show.find(filter);

    // Fetch theater details for each show
    const showsWithTheaterDetails = await Promise.all(
      shows.map(async (show) => {
        const theater = await Theater.findById(show.theaterId).select("name location");
        const screen = await Screen.findById(show.screenId);
        
        return {
          ...show._doc, // Use show._doc to access the show object
          theaterName: theater?.name || "Unknown Theater", // Add theater name
          theaterLocation: theater?.location || "Unknown Location", // Add theater location
          screenType: screen?.screenType || "Unknown ScreenType",
          screenName: screen?.name || "Unknown Screen",
          noOfRows:screen?.numberOfRows,
          capacity:screen?.capacity
        };
      })
    );

    res.status(200).json(showsWithTheaterDetails);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
};

