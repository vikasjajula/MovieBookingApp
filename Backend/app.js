import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import userRouter from "./routes/user-routes";
import adminRouter from "./routes/admin-routes";
import movieRouter from "./routes/movie-routes";
import bookingsRouter from "./routes/booking-routes";
import theaterRouter from "./routes/theater-routes";
import artistRouter from "./routes/artist-routes";
import cors from "cors";
import screenRouter from "./routes/screen-route";
import showRouter from "./routes/show-router";
dotenv.config();
const app = express();

// middlewares
app.use(cors());
app.use(express.json());
app.use("/user", userRouter);
app.use("/admin", adminRouter);
app.use("/movie", movieRouter);
app.use("/booking", bookingsRouter);
app.use("/theater",theaterRouter)
app.use("/artist",artistRouter);
app.use("/screen",screenRouter);
app.use("/show",showRouter);

mongoose
  .connect(
    `mongodb+srv://vikasjajula:${process.env.MONGODB_PASSWORD}@cluster0.evlsmin.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0`
  )
  .then(() =>
    app.listen(5000,'0.0.0.0',  () =>
      console.log("Connected To Database And Server is running")
    )
  )
  .catch((e) => console.log(e));











// Wg6QUF38mG700zSE   --mongo db password


// mongodb+srv://vikasjajula:Wg6QUF38mG700zSE@cluster0.evlsmin.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0