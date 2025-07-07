const express = require('express');
const router = express.Router();
const bloodPressureController = require('../controllers/BloodPressureController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo'); 

router.route('/')
    .post(verifyToken, allowedTo('patient'), bloodPressureController.createBloodPressure)
    .get(verifyToken, allowedTo('patient'), bloodPressureController.getAllBloodPressures)

router.route('/:id')
    .get(verifyToken, allowedTo('patient'), bloodPressureController.getBloodPressureById)
    .patch(verifyToken, allowedTo('patient'), bloodPressureController.updateBloodPressure)
    .delete(verifyToken, allowedTo('patient'), bloodPressureController.deleteBloodPressure)

module.exports = router;