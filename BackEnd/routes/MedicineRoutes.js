const express = require('express');
const router = express.Router();
const medicineController = require('../controllers/MedicineController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo');  

router.route('/')
    .post(verifyToken, allowedTo('patient'), medicineController.createMedicine)
    .get(verifyToken, allowedTo('patient'), medicineController.getAllMedicines);

router.route('/auto-complete')
    .get(verifyToken, allowedTo('doctor', 'patient'), medicineController.autoComplete);

router.route('/get-medicine-info')
    .get(verifyToken, allowedTo('patient'), medicineController.getMedicineInfo);

router.route('/:id')
    .get(verifyToken, allowedTo('patient'), medicineController.getMedicineById)
    .patch(verifyToken, allowedTo('patient'), medicineController.updateMedicine)
    .delete(verifyToken, allowedTo('patient'), medicineController.deleteMedicine);

module.exports = router;