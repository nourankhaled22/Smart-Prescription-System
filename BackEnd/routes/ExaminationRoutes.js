const express = require('express');
const router = express.Router();
const examinationController = require('../controllers/ExaminationController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo'); 
const uploads = require('../middleware/uploadExaminationFile');
const verifySessionToken = require('../middleware/verifySessionToken');

router.route('/')
    .post(verifyToken, allowedTo('patient'), uploads.single('examination'), examinationController.createExamination)
    .get(verifyToken, allowedTo('patient'), examinationController.getAllExaminations);

router.route('/:id')
    .get(verifyToken, allowedTo('patient', 'doctor'), verifySessionToken, examinationController.getExaminationById)
    .patch(verifyToken, allowedTo('patient'), examinationController.updateExamination)
    .delete(verifyToken, allowedTo('patient'), examinationController.deleteExamination);

module.exports = router;