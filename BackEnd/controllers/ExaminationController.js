const Examination = require('../models/Examination');
const asyncWrapper = require('../middleware/asyncWrapper');
const appError = require('../utils/appError');
const httpStatusText = require('../utils/httpStatusText');
const cloudinary = require('../config/cloudinaryConfig');

const createExamination = asyncWrapper(async (req, res, next) => {
    if (!req.file) {
        const error = appError.create('Examination file is required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const nationalId = req.currentUser.nationalId;
    const { examinationName, date} = req.body;   
    if (!nationalId || !examinationName || !date) {
        await cloudinary.uploader.destroy(req.file.filename);
        const error = appError.create('National ID, Examination name and date are required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const newExamination = new Examination({
        nationalId,
        examinationName,
        fileUrl: req.file.path,
        filePublicId: req.file.filename,
        date    
    });
    await newExamination.save();
    const examinationObject = newExamination.toObject();
    delete examinationObject.__v;
    delete examinationObject.createdAt;
    delete examinationObject.updatedAt;
    delete examinationObject.filePublicId;
    delete examinationObject.fileUrl;
    res.status(201).json({status: httpStatusText.SUCCESS, data:{newExamination: examinationObject}});
});

const updateExamination = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    if ('nationalId' in req.body) {
        delete req.body.nationalId;
    }
    const examination = await Examination.findById(id);
    if (!examination) {
        const error = appError.create('Examination not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (examination.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to update this examination', 401, httpStatusText.FAIL);
        return next(error);
    }
    const updatedExamination = await Examination.findOneAndUpdate(
        {_id: id},
        {$set: req.body},
        { new: true, runValidators: true }
    ).select('-__v -createdAt -updatedAt -filePublicId -fileUrl');
    return res.status(200).json({status: httpStatusText.SUCCESS, data:{updatedExamination: updatedExamination}});
});

const deleteExamination = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const examination = await Examination.findById(id);
    if (!examination) {
        const error = appError.create('Examination not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (examination.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to delete this examination', 401, httpStatusText.FAIL);
        return next(error);
    }
    const deletedExamination = await Examination.findByIdAndDelete(id);
    await cloudinary.uploader.destroy(deletedExamination.filePublicId);
    return res.status(200).json({status: httpStatusText.SUCCESS, data: null});
})

const getExaminationById = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const role = req.currentUser.role;
    if (!id) {
        return res.status(400).json({ message: 'Missing examination ID in request' });
    }
    const examination = await Examination.findById(id, {"__v": false, "createdAt": false, "updatedAt": false, "filePublicId": false});
    if (!examination) {
        const error = appError.create('Examination not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if ( (role === "patient" && examination.nationalId !== req.currentUser.nationalId) || 
        (role === "doctor" && examination.nationalId !== req.currentPatient.nationalId) ) 
    {
        const error = appError.create('You are not authorized to view this examination', 401, httpStatusText.FAIL);
        return next(error);
    }
    res.redirect(examination.fileUrl);
})

const getAllExaminations = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const examinations = await Examination.find({nationalId}, {"__v":false, "createdAt":false, "updatedAt":false, "filePublicId": false, "fileUrl": false});
    return res.status(200).json({status: httpStatusText.SUCCESS, data:{examinations: examinations}});
})

module.exports = {
    createExamination,
    updateExamination,
    deleteExamination,
    getExaminationById,
    getAllExaminations
}