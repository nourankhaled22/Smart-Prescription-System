const express = require('express');
const router = express.Router();
const prescriptionController = require('../controllers/PrescriptionController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo');
const verifySessionToken = require('../middleware/verifySessionToken');

router.route('/')
    .post(verifyToken, allowedTo('doctor'), verifySessionToken, prescriptionController.addPrescription)
    .get(verifyToken, allowedTo('patient', 'doctor'), prescriptionController.getAllPrescriptions);

router.route('/:id')
    .get(verifyToken, allowedTo('patient', 'doctor'), verifySessionToken, prescriptionController.getPrescriptionById)
    .delete(verifyToken, allowedTo('patient'), prescriptionController.deletePrescription);

module.exports = router;