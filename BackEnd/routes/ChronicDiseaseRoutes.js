const express = require('express');
const router = express.Router();
const chronicDiseaseController = require('../controllers/ChronicDiseaseController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo'); 

router.route('/')
    .post(verifyToken, allowedTo('patient'), chronicDiseaseController.createChronicDisease)
    .get(verifyToken, allowedTo('patient'), chronicDiseaseController.getAllChronicDiseases)

router.route('/:id')
    .get(verifyToken, allowedTo('patient'), chronicDiseaseController.getChronicdiseaseById)
    .patch(verifyToken, allowedTo('patient'), chronicDiseaseController.updateChronicDisease)
    .delete(verifyToken, allowedTo('patient'), chronicDiseaseController.deleteChronicDisease)

module.exports = router;