const express = require('express');
const router = express.Router();
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo'); 
const ScanMedicineController = require('../controllers/ScanMedicineController');
const upload = require('../middleware/uploadMedicineFile');

router.route('/')
    .post(verifyToken, allowedTo('patient'), upload.single('medicine'), ScanMedicineController.ScanMedicine);

module.exports = router;
