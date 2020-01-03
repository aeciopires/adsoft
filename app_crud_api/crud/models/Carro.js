const mongoose = require('mongoose');
const { Schema } = mongoose;

const carroSchema = new Schema({
  marca: {
    type: String,
    required: true
  },
  modelo: {
    type: String,
    require: true
  },
  criadoEm: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('carros', carroSchema);
