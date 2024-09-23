import express from "express";
import {
 AddScreen,
 getScreensByTheaterId
} from "../controllers/screen-controller";
const screenRouter = express.Router();

screenRouter.post("/", AddScreen);
screenRouter.get("/getScreens/:theaterID", getScreensByTheaterId);


export default screenRouter;