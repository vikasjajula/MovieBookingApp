import express from "express";
import {
  deleteBooking,
  getBookingById,
  newBooking,
  getSeatNumbers
} from "../controllers/booking-controller";

const bookingsRouter = express.Router();

bookingsRouter.get("/:id", getBookingById);
bookingsRouter.post("/", newBooking);
bookingsRouter.delete("/:id", deleteBooking);
bookingsRouter.post("/getBookedSeats",getSeatNumbers);
export default bookingsRouter;
