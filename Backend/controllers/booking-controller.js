import mongoose from "mongoose";
import Bookings from "../models/Bookings";
import Movie from "../models/Movie";
import User from "../models/User";


export const newBooking = async (req, res, next) => {
  console.log("new booking controller hit");

  const { movie, date, showtime, seats, userId ,theaterName,screenId,theaterId,movieId} = req.body;
  console.log(movie, date, showtime, seats, userId);

  // Convert date string to Date object
  const dateObject = new Date(`${new Date().getFullYear()} ${date.split(" ").slice(2).join(" ")}`);
  console.log(dateObject);

  const seatNumbers = seats;
  let existingUser;

  try {
    // Check if user exists
    existingUser = await User.findById(userId);
    if (!existingUser) {
      return res.status(404).json({ message: "User not found with given ID" });
    }
  } catch (err) {
    console.error("Error finding user:", err);
    return res.status(500).json({ message: "Failed to find user" });
  }

  let booking;

  try {
    const session = await mongoose.startSession();
    session.startTransaction();

    // Create new booking document
    booking = new Bookings({
      movie,
      date: date,
      showtime,
      seatNumbers,
      user: existingUser._id, // Reference to user ID
      theater:theaterName,
      theaterId,
      screenId,
      theaterId,
      movieId
    });

    // Save booking and update user's bookings array atomically
    await booking.save({ session });
    existingUser.bookings.push(booking);
    await existingUser.save({ session });

    await session.commitTransaction();
    session.endSession();
  } catch (err) {
    console.error("Error creating booking:", err);
    return res.status(500).json({ message: "Failed to create booking" });
  }

  if (!booking) {
    return res.status(500).json({ message: "Unable to create a booking" });
  }

  return res.status(201).json({ booking });
};

export const getBookingById = async (req, res, next) => {
  const id = req.params.id;
  let booking;
  try {
    booking = await Bookings.findById(id);
  } catch (err) {
    return console.log(err);
  }
  if (!booking) {
    return res.status(500).json({ message: "Unexpected Error" });
  }
  return res.status(200).json({ booking });
};

export const deleteBooking = async (req, res, next) => {
  const id = req.params.id;
  let booking;
  try {
    booking = await Bookings.findByIdAndRemove(id).populate("user movie");
    console.log(booking);
    const session = await mongoose.startSession();
    session.startTransaction();
    await booking.user.bookings.pull(booking);
    await booking.movie.bookings.pull(booking);
    await booking.movie.save({ session });
    await booking.user.save({ session });
    session.commitTransaction();
  } catch (err) {
    return console.log(err);
  }
  if (!booking) {
    return res.status(500).json({ message: "Unable to Delete" });
  }
  return res.status(200).json({ message: "Successfully Deleted" });
};



export const getSeatNumbers = async (req, res,next) => {
  const { movie, theater, showtime } = req.body; // Assuming query parameters are used
 debugger
  try {
      // Query the Booking model for seatNumbers
      debugger
      const bookings = await Bookings.find({
          movie: movie,
          theater: theater,
          showtime: showtime
      }).select('seatNumbers');

      if (!bookings) {
          return res.status(404).json({ message: 'No bookings found for the given criteria' });
      }

      // Extract seatNumbers from the bookings array
      const seatNumbers = bookings.map(booking => booking.seatNumbers).flat();

      res.json({ seatNumbers: seatNumbers });
  } catch (err) {
      console.error('Error fetching seat numbers:', err);
      res.status(500).json({ message: 'Server error' });
  }
};