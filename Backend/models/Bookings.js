import mongoose from "mongoose";

const bookingSchema = new mongoose.Schema({
  movie: {
    type: String,
    required: true,
  },
  theater:{
    type: String,
    required:true
  },
  showtime:{
    type:String,
    required:true
  },
  date: {
    type: String,
    required: true,
  },
  seatNumbers: {
    type: [String], // Array of strings
    required: true,
  },
  user: {
    type: mongoose.Types.ObjectId,
    ref: "User",
    required: true,
  },
  theaterId:{
    type:mongoose.Types.ObjectId,
    ref:"Theater",
    required:true
  },
  screenId:{
    type:mongoose.Types.ObjectId,
    ref:"Screen",
    required:true
  },
  movieId:{
    type:mongoose.Types.ObjectId,
    ref:"Movie",
    required:true
  }
});

export default mongoose.model("Booking", bookingSchema);
