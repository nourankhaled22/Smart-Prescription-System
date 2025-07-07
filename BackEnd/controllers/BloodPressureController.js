const BloodPressure = require('../models/BloodPressure');
const asyncWrapper = require('../middleware/asyncWrapper');
const appError = require('../utils/appError');
const httpStatusText = require('../utils/httpStatusText');

const createBloodPressure = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const {pulse, diastolic, systolic, date} = req.body;   
    if (!nationalId || !pulse || !diastolic || !systolic || !date) {
        const error = appError.create('missing fields data', 400, httpStatusText.FAIL)
        return next(error);
    }
    const newBloodPressure = new BloodPressure({
        nationalId,
        pulse,
        diastolic,
        systolic,
        date    
    });
    await newBloodPressure.save();
    const bloodPressureObject = newBloodPressure.toObject();
    delete bloodPressureObject.__v;
    delete bloodPressureObject.createdAt;
    delete bloodPressureObject.updatedAt;
    res.status(201).json({status: httpStatusText.SUCCESS, data:{newBloodPressure: bloodPressureObject}});
});

const getAllBloodPressures = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const bloodPressures = await BloodPressure.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    res.status(200).json({status: httpStatusText.SUCCESS, data: {bloodPressures: bloodPressures}});
});

const getBloodPressureById = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const bloodPressure = await BloodPressure.findById(id, {"__v":false, "createdAt":false, "updatedAt":false});
    if (!bloodPressure) {
        const error = appError.create('Blood Pressure not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (bloodPressure.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to view this blood pressure', 401, httpStatusText.FAIL);
        return next(error);
    }
    res.status(200).json({status: httpStatusText.SUCCESS, data: {bloodPressure: bloodPressure}});
});

const updateBloodPressure = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    if ('nationalId' in req.body) {
        delete req.body.nationalId;
    }
    const bloodPressure = await BloodPressure.findById(id);
    if (!bloodPressure) {
        const error = appError.create('Blood Pressure not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (bloodPressure.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to update this blood pressure', 401, httpStatusText.FAIL);
        return next(error);
    }
    const updatedBloodPressure = await BloodPressure.findOneAndUpdate(
        {_id: id},
        {$set: req.body},
        { new: true , runValidators: true },
    ).select('-__v -createdAt -updatedAt'); // exclude these fields
    return res.status(200).json({status: httpStatusText.SUCCESS, data:{updatedBloodPressure: updatedBloodPressure}});
});

const deleteBloodPressure = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const bloodPressure = await BloodPressure.findById(id);
    if (!bloodPressure) {
        const error = appError.create('Blood Pressure not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (bloodPressure.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to delete this blood pressure', 401, httpStatusText.FAIL);
        return next(error);
    }
    const deletedBloodPressure = await BloodPressure.findByIdAndDelete(id);
    return res.status(200).json({status: httpStatusText.SUCCESS, data:null});
});

module.exports = {
    createBloodPressure,
    getAllBloodPressures,
    getBloodPressureById,
    updateBloodPressure,
    deleteBloodPressure,
};  