import express from "express";
import { addArtist,getAllArtists,getArtistsByIds} from "../controllers/artist-controller"; // Adjust the path as needed

const ArtistRouter = express.Router();

// Route to add a theater
ArtistRouter.post("/", addArtist);
ArtistRouter.get("/GetAll",getAllArtists);
ArtistRouter.post("/getByIds", getArtistsByIds);

export default ArtistRouter;