import Artist from "../models/Artist.js"; // Adjust the path as needed
import mongoose from "mongoose";

// Method to add an artist
export const addArtist = async (req, res, next) => {
    console.log("Artist route hit");

    // Temporary bypass for authorization check
    // if (!req.headers.authorization) {
    //     return res.status(401).json({ message: "Authorization header is missing" });
    // }
    const extractedToken = req.headers.authorization.split(" ")[1];
    if (!extractedToken || extractedToken.trim() === "") {
        return res.status(404).json({ message: "Token Not Found" });
    }

    const { name, alsoKnownAs, occupation, born, birthplace, about, earlyLife, actingCareer, awards, imageUrl } = req.body;
    console.log(req.body);
    // Validate inputs
    if (!name || name.trim() === "" || !occupation || occupation.length === 0 || !about || about.trim() === "") {
        return res.status(422).json({ message: "Invalid Inputs" });
    }

    let artist;
    try {
        artist = new Artist({
            name,
            alsoKnownAs,
            occupation,
            born,
            birthplace,
            about,
            earlyLife,
            actingCareer,
            awards,
            imageUrl
        });

        const session = await mongoose.startSession();
        session.startTransaction();
        await artist.save({ session });
        await session.commitTransaction();
        session.endSession();
    } catch (err) {
        return res.status(500).json({ message: err.message });
    }

    return res.status(201).json({ artist });
};

export const getAllArtists = async (req, res, next) => {
    try {
        const artists = await Artist.find();
        return res.status(200).json({ artists });
    } catch (err) {
        return res.status(500).json({ message: err.message });
    }
};

export const getArtistsByIds = async (req, res, next) => {
    console.log(req)
    const { ids } = req.body;
    if (!ids || !Array.isArray(ids) || ids.length === 0) {
        return res.status(422).json({ message: "Invalid input, ids must be a non-empty array" });
    }

    try {
        const artists = await Artist.find({ _id: { $in: ids } });
        return res.status(200).json({ artists });
    } catch (err) {
        return res.status(500).json({ message: err.message });
    }
};
