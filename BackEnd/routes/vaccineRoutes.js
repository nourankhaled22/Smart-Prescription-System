const express = require('express');
const router = express.Router();
const vaccineController = require('../controllers/VaccineController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo'); 

router.route('/')
    .post(verifyToken, allowedTo('patient'), vaccineController.createVaccine)
    .get(verifyToken, allowedTo('patient'), vaccineController.getAllVaccines)

router.route('/:id')
    .get(verifyToken, allowedTo('patient'), vaccineController.getVaccineById)
    .patch(verifyToken, allowedTo('patient'), vaccineController.updateVaccine)
    .delete(verifyToken, allowedTo('patient'), vaccineController.deleteVaccine)

module.exports = router;