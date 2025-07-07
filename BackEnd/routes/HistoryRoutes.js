const express = require('express');
const router = express.Router();
const HistoryController = require('../controllers/HistoryController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo');
const verifySessionToken = require('../middleware/verifySessionToken');

router.route('/')
    .get(verifyToken, allowedTo('patient', 'doctor'), verifySessionToken, HistoryController.getHistory);

module.exports = router;