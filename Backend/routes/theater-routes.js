import express from "express";
import { addTheater, getAllTheaters } from "../controllers/theater-controller"; // Adjust the path as needed
import { getTheatersByMovieName} from "../controllers/theater-controller";
import { updateMovieAndShows } from "../controllers/theater-controller";    

const TheaterRouter = express.Router();

// Route to add a theater
TheaterRouter.post("/", addTheater);
TheaterRouter.post("/getMovieTheaters", getTheatersByMovieName);
TheaterRouter.post("/updateShowsMoives",updateMovieAndShows);
TheaterRouter.get("/getAllTheaters",getAllTheaters);

export default TheaterRouter;