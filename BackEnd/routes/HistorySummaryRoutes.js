const express = require('express');
const router = express.Router();
const HistorySummaryController = require('../controllers/HistorySummaryController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo');

router.route('/')
    .get(verifyToken, allowedTo('patient'), HistorySummaryController.getHistorySummary);

module.exports = router;