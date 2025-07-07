const ChronicDisease = require('../models/ChronicDisease');
const asyncWrapper = require('../middleware/asyncWrapper');
const appError = require('../utils/appError');
const httpStatusText = require('../utils/httpStatusText');

const createChronicDisease = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const {diseaseName, date} = req.body;   
    if (!nationalId || !diseaseName || !date) {
        const error = appError.create('National ID, Disease name and date are required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const newChronicDisease = new ChronicDisease({
        nationalId,
        diseaseName,
        date    
    });
    await newChronicDisease.save();
    const chronicDiseaseObject = newChronicDisease.toObject();
    delete chronicDiseaseObject.__v;
    delete chronicDiseaseObject.createdAt;
    delete chronicDiseaseObject.updatedAt;
    res.status(201).json({status: httpStatusText.SUCCESS, data:{newChronicDisease: chronicDiseaseObject}});
});

const getAllChronicDiseases = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const chronicDiseases = await ChronicDisease.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    res.status(200).json({status: httpStatusText.SUCCESS, data: {chronicDiseases: chronicDiseases}});
});

const getChronicdiseaseById = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const chronicDisease = await ChronicDisease.findById(id, {"__v":false, "createdAt":false, "updatedAt":false});
    if(!chronicDisease) {
        const error = appError.create('Chronic Disease not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (chronicDisease.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to view this chronic disease', 401, httpStatusText.FAIL);
        return next(error);
    }
    res.status(200).json({status: httpStatusText.SUCCESS, data: {chronicDisease: chronicDisease}});
});

const updateChronicDisease = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    if ('nationalId' in req.body) {
        delete req.body.nationalId;
    }
    const chronicDisease = await ChronicDisease.findById(id);
    if (!chronicDisease) {
        const error = appError.create('Chronic Disease not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (chronicDisease.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to update this chronic disease', 401, httpStatusText.FAIL);
        return next(error);
    }
    const updatedChronicDisease = await ChronicDisease.findOneAndUpdate(
        {_id: id},
        {$set: req.body},
        { new: true , runValidators: true}
    ).select('-__v -createdAt -updatedAt'); // exclude these fields
    return res.status(200).json({status: httpStatusText.SUCCESS, data:{updatedChronicDisease: updatedChronicDisease}});
});

const deleteChronicDisease = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const chronicDisease = await ChronicDisease.findById(id);
    if (!chronicDisease) {
        const error = appError.create('Chronic Disease not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (chronicDisease.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to delete this chronic disease', 401, httpStatusText.FAIL);
        return next(error);
    }
    const deletedChronicDisease = await ChronicDisease.findByIdAndDelete(id);
    return res.status(200).json({status: httpStatusText.SUCCESS, data:null});
});

module.exports = {
    createChronicDisease,
    getAllChronicDiseases,
    getChronicdiseaseById,
    updateChronicDisease,
    deleteChronicDisease,
}; 