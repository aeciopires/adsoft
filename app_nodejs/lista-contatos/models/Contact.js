// Contact.js
const mongoose = require('mongoose');

// Create a new Schema with the fields used by the Contact model
const ContactSchema = new mongoose.Schema({
  name: String,
  email: String,
  // Stored as String to keep the phone formatting, e.g. (00) 0000-0000
  phone: String,
});

// Define the Contact model
mongoose.model('Contact', ContactSchema);
