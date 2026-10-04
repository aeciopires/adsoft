// STARTING ===============================================
// Define the libraries used
const path = require('path');
const express = require('express');
const mongoose = require('mongoose');

const router = express.Router();
const Contact = mongoose.model('Contact');

// Return the error in the response
function sendError(res, error) {
  res.status(500).json({ error: error.message });
}

// LIST ROUTE =============================================
router.get('/api/contacts', async (req, res) => {
  try {
    // Use mongoose to find all the contacts in the database
    res.json(await Contact.find());
  } catch (error) {
    sendError(res, error);
  }
});

// CREATE ROUTE ===========================================
router.post('/api/contacts', async (req, res) => {
  try {
    // Create a contact. The data is sent by an AJAX request from Angular
    await Contact.create({
      name: req.body.name,
      email: req.body.email,
      phone: req.body.phone,
    });
    // Return all the contacts after inserting the new record
    res.json(await Contact.find());
  } catch (error) {
    sendError(res, error);
  }
});

// DELETE ROUTE ===========================================
router.delete('/api/contacts/:contact_id', async (req, res) => {
  try {
    // Remove the contact using the _id parameter
    await Contact.deleteOne({ _id: req.params.contact_id });
    // Return all the contacts after removing the record
    res.json(await Contact.find());
  } catch (error) {
    sendError(res, error);
  }
});

// GET ONE ROUTE (used by the edit form) ==================
router.get('/api/contacts/:contact_id', async (req, res) => {
  try {
    res.json(await Contact.findById(req.params.contact_id));
  } catch (error) {
    sendError(res, error);
  }
});

// UPDATE ROUTE ===========================================
router.put('/api/contacts/:contact_id', async (req, res) => {
  try {
    const contact = await Contact.findByIdAndUpdate(
      req.params.contact_id,
      { name: req.body.name, email: req.body.email, phone: req.body.phone },
      { returnDocument: 'after' }
    );
    res.json(contact);
  } catch (error) {
    sendError(res, error);
  }
});

// ROUTE FOR THE ANGULARJS FRONT-END ======================
router.get('/{*splat}', (req, res) => {
  // Load the index.html view, the only one of the application.
  // Angular handles the page changes in the front-end.
  res.sendFile(path.join(__dirname, '..', 'public', 'index.html'));
});

module.exports = router;
