// STARTING ===========================================

const path = require('path');
const express = require('express');
// mongoose for mongodb
const mongoose = require('mongoose');
// log requests to the console
const logger = require('morgan');
// simulate DELETE and PUT
const methodOverride = require('method-override');

// create our Express application
const app = express();

// MONGODB ============================================
// Connection string of MongoDB. It can be changed with the MONGODB_URI environment variable.
const mongodbUri = process.env.MONGODB_URI || 'mongodb://db:27017/contact';
const port = process.env.PORT || 8080;

// Load the file that creates the Contact model
require('./models/Contact');

// DEFINING THE APPLICATION ===========================
// location of the public files
app.use(express.static(path.join(__dirname, 'public')));
// log all requests to the console
app.use(logger('dev'));
// parse application/x-www-form-urlencoded
app.use(express.urlencoded({ extended: true }));
// parse application/json and application/vnd.api+json as json
app.use(express.json({ type: ['application/json', 'application/vnd.api+json'] }));
app.use(methodOverride());

// ROUTES ==============================================
// Include the routes defined in the file routes/index.js
app.use('/', require('./routes/index'));

// LISTEN (starting our node application) =============
mongoose
  .connect(mongodbUri)
  .then(() => {
    console.log('Connected to MongoDB');
    app.listen(port, () => console.log(`Application running on port ${port}`));
  })
  .catch((error) => {
    console.error('Error connecting to MongoDB:', error.message);
    process.exit(1);
  });
