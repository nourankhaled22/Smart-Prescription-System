
const express = require('express');
const router = express.Router();
const authController = require('../controllers/AuthController');
const upload = require('../middleware/uploadLicenceFile')
const verifyToken = require('../middleware/verifyToken');

router.route('/')
    .get(verifyToken, authController.getProfile)
    .patch(verifyToken, authController.updateProfile);

router.route('/patient-register')
    .post(authController.patientRegister)

router.route('/doctor-register')
    .post(upload.single('licence'), authController.doctorRegister)

router.route('/verify-otp')
    .post(authController.verifyOtp)

router.route('/resend-otp')
    .post(authController.resendOtp)

router.route('/login')
    .post(authController.login)

router.route('/reset-for-forget-password/:phoneNumber')
    .patch(authController.resetForForgetPassword);

router.route('/reset-password')
    .patch(verifyToken, authController.resetPassword);

router.route('/forget-password')
    .post(authController.forgetPassword);

router.route('/verify-otp-for-forget-password/:phoneNumber')
    .post(authController.verifyOtpForForgetPassword);

router.route('/is-valid-token')
    .get(authController.isValidSessionToken);

// router.route('/add-admin')
//             .post(authController.addAdmin)


module.exports = router;
