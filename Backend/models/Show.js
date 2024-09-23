import mongoose from "mongoose";
import dayjs from "dayjs";

const showSchema = new mongoose.Schema({
  movieId: { type: mongoose.Types.ObjectId, ref: 'Movie', required: true },
  theaterId: { type: mongoose.Types.ObjectId, ref: 'Theater', required: true },
  screenId: { type: mongoose.Types.ObjectId, ref: 'Screen', required: true },
  date: { type: Date, required: true },  // Only for the date
  startTime: { type: String, required: true }, // Store start time as a string (e.g., "09:30 AM")
  endTime: { type: String, required: true },  // Store end time as a string (e.g., "12:00 PM")
  standardPrice: { type: Number, required: true }
});

// No need for UTC conversion as we are storing time as a string
export default mongoose.model('Show', showSchema);
