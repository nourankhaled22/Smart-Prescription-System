const express = require('express');
const router = express.Router();
const ChatbotController = require('../controllers/ChatbotController');
const verifyToken = require('../middleware/verifyToken');
const allowedTo = require('../middleware/allowedTo');
router.route('/')
    .post(verifyToken, allowedTo('patient'), ChatbotController.askChatbot)
    .delete(verifyToken, allowedTo('patient'), ChatbotController.deleteChat)


module.exports = router;
