import mongoose from "mongoose";

const movieSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
  actors: [{ type:mongoose.Types.ObjectId, ref:"Artist" }],
  crew:[{ type:mongoose.Types.ObjectId, ref:"Artist" }],
  releaseDate: {
    type: Date,
    required: true,
  },
  posterUrl: {
    type: String,
    required: true,
  },
  bigposterUrl: {
    type: String,
    required: true,
  },
  genres:{
    type:[String],
    required:true
  },
  duration:{
    type:String,
    required:true
  },
  certificationRating:{
    type:String,
    required:true
  
  },
  displayFormats:{
    type:[String],
    required:true
  },
  theaters:{
    type: [{ type: mongoose.Types.ObjectId, ref: "Theater" }],
    required:false
  },
  featured: {
    type: Boolean,
  },
  bookings: [{ type: mongoose.Types.ObjectId, ref: "Booking" }],
  admin: {
    type: mongoose.Types.ObjectId,
    ref: "Admin",
    required: true,
  },
});

export default mongoose.model("Movie", movieSchema);
