const Vaccine = require('../models/Vaccine');
const asyncWrapper = require('../middleware/asyncWrapper');
const appError = require('../utils/appError');
const httpStatusText = require('../utils/httpStatusText');

const createVaccine = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const {vaccineName, date} = req.body;   
    if (!nationalId || !vaccineName || !date) {
        const error = appError.create('National ID, Vaccine name and date are required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const newVaccine = new Vaccine({
        nationalId,
        vaccineName,
        date    
    });
    await newVaccine.save();
    const vaccineObject = newVaccine.toObject();
    delete vaccineObject.__v;
    delete vaccineObject.createdAt;
    delete vaccineObject.updatedAt;
    res.status(201).json({status: httpStatusText.SUCCESS, data:{newVaccine: vaccineObject}});
});

const getAllVaccines = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const vaccines = await Vaccine.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    res.status(200).json({status: httpStatusText.SUCCESS, data: {vaccines: vaccines}});
});

const getVaccineById = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const vaccine = await Vaccine.findById(id, {"__v":false, "createdAt":false, "updatedAt":false});
    if (!vaccine) {
        const error = appError.create('Vaccine not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (vaccine.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to view this vaccine', 401, httpStatusText.FAIL);
        return next(error);
    }
    res.status(200).json({status: httpStatusText.SUCCESS, data: {vaccine: vaccine}});
});

const updateVaccine = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    if ('nationalId' in req.body) {
        delete req.body.nationalId;
    }
    const vaccine = await Vaccine.findById(id);
    if (!vaccine) {
        const error = appError.create('Vaccine not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (vaccine.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to update this vaccine', 401, httpStatusText.FAIL);
        return next(error);
    }
    const updatedVaccine = await Vaccine.findOneAndUpdate(
        {_id: id},
        {$set: req.body},
        { new: true, runValidators: true }
    ).select('-__v -createdAt -updatedAt');
    return res.status(200).json({status: httpStatusText.SUCCESS, data:{updatedVaccine: updatedVaccine}});
});

const deleteVaccine = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const vaccine = await Vaccine.findById(id);
    if (!vaccine) {
        const error = appError.create('Vaccine not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (vaccine.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to delete this vaccine', 401, httpStatusText.FAIL);
        return next(error);
    }
    const deletedVaccine = await Vaccine.findByIdAndDelete(id);
    return res.status(200).json({status: httpStatusText.SUCCESS, data:null});
});

module.exports = {
    createVaccine,
    getAllVaccines,
    getVaccineById,
    updateVaccine,
    deleteVaccine,
}; 