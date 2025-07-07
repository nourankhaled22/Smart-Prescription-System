const express = require('express');
const router = express.Router();
const allergyController = require('../controllers/AllergyController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo'); 

router.route('/')  
    .post(verifyToken, allowedTo('patient'), allergyController.createAllergy)
    .get(verifyToken, allowedTo('patient'), allergyController.getAllAllergies)

router.route('/:id') 
    .get(verifyToken, allowedTo('patient'), allergyController.getAllergyById)
    .patch(verifyToken, allowedTo('patient'), allergyController.updateAllergy)
    .delete(verifyToken, allowedTo('patient'), allergyController.deleteAllergy);

module.exports = router;