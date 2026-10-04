const express = require('express');
const mongoose = require('mongoose');

// Connection string of MongoDB. It can be changed with the MONGODB_URI environment variable.
const mongodbUri = process.env.MONGODB_URI || 'mongodb://db:27017/crud-node-mongo-docker';
const port = process.env.PORT || 9000;

const app = express();

app.use(express.json());

// Add the routes file on the /api/cars endpoint
const cars = require('./routes/cars');

app.use('/api/cars', cars);

mongoose
  .connect(mongodbUri)
  .then(() => {
    console.log('MongoDB connected');
  })
  .catch(error => {
    console.log(error);
  });

app.listen(port, () => console.log(`Server running on port ${port}`));
