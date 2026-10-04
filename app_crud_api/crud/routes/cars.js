const express = require('express');
const router = express.Router();

const Car = require('../models/Car');

// Return an array with all the documents of the database
router.get('/', (req, res) => {
  Car.find()
    .then(cars => {
      res.json(cars);
    })
    .catch(error => res.status(500).json(error));
});

// Create a new document and save it in the database
router.post('/new', (req, res) => {
  const newCar = new Car({
    brand: req.body.brand,
    model: req.body.model
  });

  newCar
    .save()
    .then(car => {
      res.json(car);
    })
    .catch(error => {
      res.status(500).json(error);
    });
});

// Update the data of an existing car
router.put('/edit/:id', (req, res) => {
  const newData = { brand: req.body.brand, model: req.body.model };

  Car.findOneAndUpdate({ _id: req.params.id }, newData, { returnDocument: 'after', runValidators: true })
    .then(car => {
      res.json(car);
    })
    .catch(error => res.status(500).json(error));
});

// Delete a car from the database
router.delete('/delete/:id', (req, res) => {
  Car.findOneAndDelete({ _id: req.params.id })
    .then(car => {
      res.json(car);
    })
    .catch(error => res.status(500).json(error));
});

module.exports = router;
