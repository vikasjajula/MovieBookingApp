import jwt from "jsonwebtoken";
import mongoose from "mongoose";
import Screen from "../models/Screen";
import Theater  from "../models/Theater";

export const AddScreen = async (req, res) => {
    try {
      const { name , capacity ,theaterID, screenType, numberOfRows } = req.body;
      if (!name || !capacity || !theaterID || !screenType || numberOfRows === undefined) {
        return res.status(400).json({ message: 'All fields are required' });
      }
      const theater = await Theater.findById(theaterID);
      if (!theater) {
        return res.status(404).json({ message: 'Theater not found' });
      }
      const newScreen = new Screen({
        name,
        capacity,
        theaterID,
        screenType,
        numberOfRows
      });
      // Save the screen to the database
      const savedScreen = await newScreen.save();
      // Respond with the saved screen
      res.status(201).json(savedScreen);
    } catch (error) {
      // Handle errors
      console.error(error);
      res.status(500).json({ message: 'Server error' });
    }
  };


  export const getScreensByTheaterId = async (req, res) => {
    const { theaterID } = req.params;
  
    try {
      // Check if the theater exists
      const theater = await Theater.findById(theaterID);
      if (!theater) {
        return res.status(404).json({ message: 'Theater not found' });
      }
  
      // Find all screens associated with the theaterID
      const screens = await Screen.find({ theaterID:theaterID });
      
      if (screens.length === 0) {
        return res.status(404).json({ message: 'No screens found for this theater' });
      }
  
      // Respond with the list of screens
      res.status(200).json(screens);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Server error' });
    }
  };
  


