const express = require('express');
const router = express.Router();
const patientController = require('../controllers/PatientController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo');

router.route('/generate-qr')
    .get(verifyToken, allowedTo('patient'), patientController.generateQR);

router.route('/:id')
    .get(verifyToken, allowedTo('admin'), patientController.getPatientById);

router.route('/')
    .get(verifyToken, allowedTo('admin'), patientController.getAllPatients);

router.route('/suspend-patient/:id')
    .patch(verifyToken, allowedTo('admin'), patientController.suspendPatient);

router.route('/activate-patient/:id')
    .patch(verifyToken, allowedTo('admin'), patientController.activatePatient);

module.exports = router;