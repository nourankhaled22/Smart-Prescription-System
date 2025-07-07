const asyncWrapper = require("../middleware/asyncWrapper");
const Doctor = require("../models/Doctor");
const httpStatusText = require('../utils/httpStatusText');
const appError = require('../utils/appError');
const cloudinary = require('../config/cloudinaryConfig');
const sendWhatsAppMessage = require('../utils/whatsAppSender');

const getDoctorById = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const doctor = await Doctor.findById(id, {"__v": false, "createdAt": false, "updatedAt": false, "password": false, "licencePublicId": false });
    if (!doctor) {
        const error = appError.create('doctor not found, incorrect Id', 404, httpStatusText.ERROR)
        return next(error);
    }
    res.status(200).json({status: httpStatusText.SUCCESS, data:{doctor: doctor}});
});

const getAllUnverifiedDoctors = asyncWrapper(async (req, res, next) => {
    const doctors = await Doctor.find({status: 'unverified'}, {"__v": false, "createdAt": false, "updatedAt": false, "password": false, "licencePublicId": false});
    res.status(200).json({status: httpStatusText.SUCCESS, data:{doctors: doctors}});
});

const getAllActiveDoctors = asyncWrapper(async (req, res, next) => {
    const specialization = req.query.specialization;
    if (specialization) {
        const doctors = await Doctor.find({status: 'active', specialization: specialization}, {"__v": false, "createdAt": false, "updatedAt": false, "password": false, "licencePublicId": false});
        return res.status(200).json({status: httpStatusText.SUCCESS, data:{doctors: doctors}});
    }
    const doctors = await Doctor.find({status: 'active'}, {"__v": false, "createdAt": false, "updatedAt": false, "password": false, "licencePublicId": false});
    res.status(200).json({status: httpStatusText.SUCCESS, data:{doctors: doctors}});
});

const getAllActiveAndSuspendedDoctors = asyncWrapper(async (req, res, next) => {
    const doctors = await Doctor.find({status: {$in: ['active', 'suspended']}}, {"__v": false, "createdAt": false, "updatedAt": false, "password": false, "licencePublicId": false});
    res.status(200).json({status: httpStatusText.SUCCESS, data:{doctors: doctors}});
});

// suspend
const suspendDoctor = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const updatedDoctor = await Doctor.findOneAndUpdate(
        {_id: id}, 
        {$set: {status: 'suspended'}}, 
        { new: true } // Return the updated document
    ).select('-__v -createdAt -updatedAt -password -licencePublicId');
    if (!updatedDoctor) {
        const error = appError.create('doctor not found, incorrect Id', 404, httpStatusText.FAIL)
        return next(error);
    }
    await sendWhatsAppMessage(`2${updatedDoctor.phoneNumber}`, 'From Smart Prescription System Application,You have been suspended by the admin');
    res.status(200).json({status: httpStatusText.SUCCESS, data:{doctor: updatedDoctor}});
});

// active

const activateDoctor = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const updatedDoctor = await Doctor.findOneAndUpdate(
        {_id: id}, 
        {$set: {status: 'active'}}, 
        { new: true } // Return the updated document
    ).select('-__v -createdAt -updatedAt -password -licencePublicId');
    if (!updatedDoctor) {
        const error = appError.create('doctor not found, incorrect Id', 404, httpStatusText.FAIL)
        return next(error);
    }

    await sendWhatsAppMessage(`2${updatedDoctor.phoneNumber}`, 'From Smart Prescription System Application, You have been activated by the admin');

    res.status(200).json({status: httpStatusText.SUCCESS, data:{doctor: updatedDoctor} });
});

// reject
const rejectDoctor = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    // delete from database
    const deletedDoctor = await Doctor.findOneAndDelete({_id: id, status: 'unverified'}, {"__v": false, "createdAt": false, "updatedAt": false, "password": false});
    if (!deletedDoctor) {
        const error = appError.create('doctor not found, incorrect Id', 404, httpStatusText.FAIL)
        return next(error);
    }
    await cloudinary.uploader.destroy(deletedDoctor.licencePublicId);
    await sendWhatsAppMessage(`2${deletedDoctor.phoneNumber}`, 'From Smart Prescription System Application, You have been rejected by the admin, because your licence is not valid');
    res.status(200).json({status: httpStatusText.SUCCESS, data:null});
})

const viewLicence = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    if (req.currentUser.role === "doctor" && req.currentUser.id !== id) {
        const error = appError.create('You are not authorized to view this licence', 401, httpStatusText.FAIL);
        return next(error);
    }
    const doctor = await Doctor.findById(id, {"__v": false, "createdAt": false, "updatedAt": false, "password": false, "licencePublicId": false});
    res.redirect(doctor.licenceUrl);
});

module.exports = {
    getDoctorById,
    getAllUnverifiedDoctors,
    getAllActiveDoctors,
    getAllActiveAndSuspendedDoctors,
    suspendDoctor,
    activateDoctor,
    rejectDoctor,
    viewLicence
};