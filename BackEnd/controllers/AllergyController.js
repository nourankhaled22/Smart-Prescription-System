const Allergy = require('../models/Allergy');
const asyncWrapper = require('../middleware/asyncWrapper');
const appError = require('../utils/appError');
const httpStatusText = require('../utils/httpStatusText');

const createAllergy = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const {allergyName, date} = req.body;   
    if (!nationalId || !allergyName || !date) {
        const error = appError.create('National ID, Allergy name and date are required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const newAllergy = new Allergy({
        nationalId,
        allergyName,
        date    
    });
    await newAllergy.save();
    const newAllergyObject = newAllergy.toObject();
    delete newAllergyObject.__v;
    delete newAllergyObject.createdAt;
    delete newAllergyObject.updatedAt;
    res.status(201).json({status: httpStatusText.SUCCESS, data:{newAllergy: newAllergyObject}});
});

const getAllAllergies = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const allergies = await Allergy.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    res.status(200).json({status: httpStatusText.SUCCESS, data: {allergies: allergies}});
});

const getAllergyById = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const allergy = await Allergy.findById({_id: id}, {"__v":false, "createdAt":false, "updatedAt":false});
    if (!allergy) {
        const error = appError.create('Allergy not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (allergy.nationalId === req.currentUser.nationalId) {
        res.status(200).json({status: httpStatusText.SUCCESS, data: {allergy: allergy}});
    }
    else {
        const error = appError.create('You are not authorized to view this allergy', 401, httpStatusText.FAIL);
        return next(error);
    }
});

const updateAllergy = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    if ('nationalId' in req.body) {
        delete req.body.nationalId;
    }
    const allergy = await Allergy.findById(id);
    if (!allergy) {
        const error = appError.create('Allergy not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (allergy.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to update this allergy', 401, httpStatusText.FAIL);
        return next(error);
    }
    const updatedAllergy = await Allergy.findOneAndUpdate(
        {_id: id},
        {$set: req.body},
        { new: true , runValidators: true}
    ).select('-__v -createdAt -updatedAt'); // exclude these fields
    return res.status(200).json({status: httpStatusText.SUCCESS, data:{updatedAllergy: updatedAllergy}});
});

// Delete
const deleteAllergy = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const allergy = await Allergy.findById(id);
    if (!allergy) {
        const error = appError.create('Allergy not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (allergy.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to delete this allergy', 401, httpStatusText.FAIL);
        return next(error);
    }
    const deletedAllergy = await Allergy.findByIdAndDelete(req.params.id);
    return res.status(200).json({status: httpStatusText.SUCCESS, data:null});
});

module.exports = {
    createAllergy,
    getAllAllergies,
    getAllergyById,
    updateAllergy,
    deleteAllergy,
};