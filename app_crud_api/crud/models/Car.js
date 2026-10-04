const mongoose = require('mongoose');
const { Schema } = mongoose;

const carSchema = new Schema({
  brand: {
    type: String,
    required: true
  },
  model: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('cars', carSchema);
