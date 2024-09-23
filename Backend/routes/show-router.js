import express from "express";
import { AddShow, getShows } from "../controllers/show-controller"; // import the new method

const showRouter = express.Router();

// Route for adding a show
showRouter.post("/", AddShow);

// Route for getting shows (all shows or filtered by movieId and date)
showRouter.post("/getshows", getShows);

export default showRouter;
