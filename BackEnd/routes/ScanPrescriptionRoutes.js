const express = require('express');
const router = express.Router();
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo'); 
const ScanPrescriptionController = require('../controllers/ScanPrescriptionController');
const upload = require('../middleware/uploadPrescriptionFile');

router.route('/')
    .post(verifyToken, allowedTo('patient'), upload.single('prescription'), ScanPrescriptionController.ScanPrescription);

module.exports = router;
