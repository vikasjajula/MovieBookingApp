import mongoose from "mongoose";

const theaterSchema = new mongoose.Schema({
        location:{
        type:String,
        required:true
         },
        name: {
        type: String,
        required: true,
        },
        shows:{
            type:[{type:String,required:true}]
        },
        movie: {
            type:String,
            required: true,
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


export default mongoose.model("Theater", theaterSchema);
