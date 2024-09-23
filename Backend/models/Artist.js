import mongoose from "mongoose";

const artistSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
      },
      alsoKnownAs: {
        type: String,
      },
      occupation: {
        type: [String],
        required: true,
      },
      born: {
        type: Date,
        required: true,
      },
      birthplace: {
        type: String,
        required: true,
      },
      about: {
        type: String,
        required: true,
      },
      earlyLife: {
        type: String,
        required: false,
      },
      actingCareer: {
        type: String,
        required: false,
      },
      awards: {
        type: [String],
      },
      imageUrl: {
        type: String,
      },
        });

//   dates: {
//     type: Array,
//     required: true,
//   },
//   bookedSeats: {
//     type: Array,
//     required: true,
//   },


export default mongoose.model("Artist", artistSchema);
