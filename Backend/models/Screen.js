import mongoose from "mongoose";
const screenSchema = new mongoose.Schema({
    name:{
     type:String,
     required:true
    },
    theaterID: { 
      type: mongoose.Types.ObjectId, 
      ref: 'Theater', 
      required: true 
    },
    screenType: { 
      type: String, 
      enum: ['IMAX', '4DX', 'Standard', 'Dolby Atmos', '3D', 'VIP'], // Example screen types
      required: true
    },
    numberOfRows: { 
      type: Number, 
      required: true 
    },
    capacity: { 
      type: Number, 
      required: true 
    }
  });
  
  export default mongoose.model('Screen', screenSchema);
