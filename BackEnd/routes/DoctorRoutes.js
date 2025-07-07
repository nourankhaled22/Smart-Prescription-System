const express = require('express');
const router = express.Router();
const doctorController = require('../controllers/DoctorController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo');

router.route('/get-all-unverified-doctors')
        .get(verifyToken, allowedTo('admin'), doctorController.getAllUnverifiedDoctors);

router.route('/get-all-acive-doctors')
        .get(verifyToken, allowedTo('admin', 'patient'), doctorController.getAllActiveDoctors);

router.route('/get-all-acive-and-suspended-doctors')
        .get(verifyToken, allowedTo('admin'), doctorController.getAllActiveAndSuspendedDoctors);

router.route('/:id') 
.get(verifyToken, allowedTo('admin', 'patient'), doctorController.getDoctorById);

router.route('/suspend-doctor/:id')
        .patch(verifyToken, allowedTo('admin'), doctorController.suspendDoctor);

router.route('/activate-doctor/:id')
        .patch(verifyToken, allowedTo('admin'), doctorController.activateDoctor);

router.route('/reject-doctor/:id')
        .delete(verifyToken, allowedTo('admin'), doctorController.rejectDoctor);

router.route('/view-licence/:id')
        .get(verifyToken, allowedTo('admin', 'doctor'), doctorController.viewLicence);


module.exports = router;    