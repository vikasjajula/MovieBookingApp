import Theater from "../models/Theater"; // Adjust the path as needed
import mongoose from "mongoose";
import Admin from "../models/Admin";
import Movie from "../models/Movie"; // Adjust the path as needed

// Method to add a theater
export const addTheater = async (req, res, next) => {
    debugger
    console.log("theater controller hit");
    const extractedToken = req.headers.authorization.split(" ")[1];
    if (!extractedToken && extractedToken.trim() === "") {
      return res.status(404).json({ message: "Token Not Found" });
    }
  
    // let adminId;
  
    // // verify token
    // jwt.verify(extractedToken, process.env.SECRET_KEY, (err, decrypted) => {
    //   if (err) {
    //     return res.status(400).json({ message: `${err.message}` });
    //   } else {
    //     adminId = decrypted.id;
    //     return;
    //   }
    // });
  
    //create new movie
    const { name, movie, location, shows , adminId} =
      req.body;
    if (
      !name &&
      movie.trim() === "" &&
      !description &&
      location.trim() == "" &&
      !shows &&
      shows.length !== 0 
    ) {
      return res.status(422).json({ message: "Invalid Inputs" });
    }
  
    let theater;
    try {
      theater = new Theater({
        name,
        location,
        movie,
        shows,
      });
      debugger
      const session = await mongoose.startSession();
      console.log(adminId);
      const adminUser = await Admin.findById(adminId);
      console.log(adminUser);
      session.startTransaction();
      await theater.save({ session });
      adminUser.addedTheaters.push(theater);
      await adminUser.save({ session });
      await session.commitTransaction();
    } catch (err) {
      return console.log(err);
    }
}

export const updateMovieAndShows = async (req, res) => {
    const { theaterId, theaterName, movieDetails, showDetails } = req.body;
  
    try {
      // Find the theater by ID and name
      const theater = await Theater.findOne({ _id: theaterId, name: theaterName });
  
      if (!theater) {
        return res.status(404).json({ message: 'Theater not found' });
      }
  
      // Update the movie details
      let movie = await Movie.findById(theater.movie);
      if (!movie) {
        return res.status(404).json({ message: 'Movie not found' });
      }
  
      movie.title = movieDetails.title || movie.title;
      movie.description = movieDetails.description || movie.description;
      movie.posterUrl = movieDetails.posterUrl || movie.posterUrl;
      movie.releaseDate = movieDetails.releaseDate || movie.releaseDate;
      movie.featured = movieDetails.featured !== undefined ? movieDetails.featured : movie.featured;
      movie.actors = movieDetails.actors || movie.actors;
      movie.crew = movieDetails.crew || movie.crew;
  
      await movie.save();
  
      // Update the show details in the theater schema
      theater.shows = showDetails || theater.shows;
  
      await theater.save();
  
      res.status(200).json({ message: 'Theater and movie updated successfully', theater, movie });
    } catch (error) {
      res.status(500).json({ message: 'An error occurred', error });
    }
  };


export const getTheatersByMovieName = async (req, res) => {
  console.log("controller hitt");
  const { movieName } = req.body;
  console.log(movieName);
  try {
    const theaters = await Theater.find({ movie: movieName });
    if (theaters.length === 0) {
      return res.status(404).json({ message: 'No theaters found for this movie' });
    }

    res.status(200).json({ theaters });
  } catch (error) {
    res.status(500).json({ message: 'An error occurred', error });
  }
};

export const getAllTheaters = async (req, res, next) => {
  let theaters;
  try {
    theaters = await Theater.find();
  } catch (err) {
    return console.log(err);
  }

  if (!theaters) {
    return res.status(500).json({ message: "Request Failed" });
  }
  return res.status(200).json({ theaters });
};

