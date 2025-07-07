const asyncWrapper = require("../middleware/asyncWrapper");
const Patient = require("../models/Patient");
const httpStatusText = require('../utils/httpStatusText');
const appError = require('../utils/appError');
const QRCode = require('qrcode');
const generateJWTForSessionToken = require("../utils/generateJWTForSessionToken");
const sendWhatsAppMessage = require('../utils/whatsAppSender');

const getPatientById = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const patient = await Patient.findById(id, {"__v": false, "createdAt": false, "updatedAt": false, "password": false, "chats": false});
    if (!patient) {
        const error = appError.create('patient not found, incorrect Id', 404, httpStatusText.FAIL)
        return next(error);
    }
    res.status(200).json({status: httpStatusText.SUCCESS, date:{patient: patient}});
});

const getAllPatients = asyncWrapper(async (req, res, next) => {
    const patients = await Patient.find({}, {"__v": false, "createdAt": false, "updatedAt": false, "password": false, "chats": false});
    res.status(200).json({status: httpStatusText.SUCCESS, data:{patients: patients}});
});

const suspendPatient = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const updatedPatient = await Patient.findOneAndUpdate(
        {_id: id}, 
        {$set: {status: 'suspended'}}, 
        { new: true } // Return the updated document
    ).select('-__v -createdAt -updatedAt -password -chats');
    if (!updatedPatient) {
        const error = appError.create('patient not found, incorrect Id', 404, httpStatusText.FAIL)
        return next(error);
    }
    await sendWhatsAppMessage(`2${updatedPatient.phoneNumber}`, 'From Smart Prescription System Application, You have been suspended by the admin');
    res.status(200).json({status: httpStatusText.SUCCESS, data:{patient: updatedPatient}});
});

const activatePatient = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const updatedPatient = await Patient.findOneAndUpdate(
        {_id: id}, 
        {$set: {status: 'active'}}, 
        { new: true } // Return the updated document
    ).select('-__v -createdAt -updatedAt -password -chats');
    if (!updatedPatient) {
        const error = appError.create('patient not found, incorrect Id', 404, httpStatusText.FAIL)
        return next(error);
    }
    await sendWhatsAppMessage(`2${updatedPatient.phoneNumber}`, 'From Smart Prescription System Application, You have been activated by the admin');
    res.status(200).json({status: httpStatusText.SUCCESS, data:{patient: updatedPatient} });
});

const generateQR = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const sessionToken = await generateJWTForSessionToken({nationalId: nationalId});
    try {
        res.setHeader('Content-Type', 'image/png');
        // Pipe QR code PNG stream to response
        QRCode.toFileStream(res, sessionToken, {
            type: 'png',
            errorCorrectionLevel: 'H'
        });
    } catch (err) {
        const error = appError.create('QR generation failed', 500, httpStatusText.ERROR)
        return next(error);
    }
});


module.exports = {
    getPatientById,
    getAllPatients,
    suspendPatient,
    activatePatient,
    generateQR
};  