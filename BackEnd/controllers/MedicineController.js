const Medicine = require('../models/Medicine');
const asyncWrapper = require('../middleware/asyncWrapper');
const appError = require('../utils/appError');
const httpStatusText = require('../utils/httpStatusText');
const medicines = require('../medicines')
const configureGemini = require("../config/ai-config");
const { lang } = require('moment-timezone');


const createMedicine = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const {medicineName, frequency, duration, dosage, afterMeal, date} = req.body;   
    if (!nationalId || !medicineName) {
        const error = appError.create('National ID and Medicine name are required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const newMedicine = new Medicine({
        nationalId,
        medicineName,
        frequency,
        duration,
        dosage,
        afterMeal,
        date
    });
    await newMedicine.save();
    const medicineObject = newMedicine.toObject();
    delete medicineObject.__v;
    delete medicineObject.createdAt;
    delete medicineObject.updatedAt;
    res.status(201).json({status: httpStatusText.SUCCESS, data:{newMedicine: medicineObject}});
});

const getAllMedicines = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    const medicines = await Medicine.find({nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    res.status(200).json({status: httpStatusText.SUCCESS, data: {medicines: medicines}});
});

const getMedicineById = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const medicine = await Medicine.findById(id, {"__v":false, "createdAt":false, "updatedAt":false});
    if (!medicine) {
        const error = appError.create('Medicine not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (medicine.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to view this medicine', 401, httpStatusText.FAIL);
        return next(error);
    }
    res.status(200).json({status: httpStatusText.SUCCESS, data: {medicine: medicine}});
});

const updateMedicine = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    if ('nationalId' in req.body) {
        delete req.body.nationalId;
    }
    const medicine = await Medicine.findById(id);
    if (!medicine) {
        const error = appError.create('Medicine not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (medicine.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to update this medicine', 401, httpStatusText.FAIL);
        return next(error);
    }
    const updatedMedicine = await Medicine.findOneAndUpdate(
        {_id: id},
        {$set: req.body},
        { new: true, runValidators: true }
    ).select('-__v -createdAt -updatedAt');
    return res.status(200).json({status: httpStatusText.SUCCESS, data:{updatedMedicine: updatedMedicine}});
});

const deleteMedicine = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const medicine = await Medicine.findById(id);
    if (!medicine) {
        const error = appError.create('Medicine not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (medicine.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to delete this medicine', 401, httpStatusText.FAIL);
        return next(error);
    }
    const deletedMedicine = await Medicine.findByIdAndDelete(id);
    return res.status(200).json({status: httpStatusText.SUCCESS, data:null});
});

const autoComplete = asyncWrapper(async(req, res, next) => {
    const query = req.query.name?.toLowerCase() || '';
    const results = medicines.filter(name =>
        name.toLowerCase().startsWith(query)
    );
    const topFive = results.slice(0, 5); // Get the first 5 matches
    res.json(topFive);
});


const getMedicineInfo = asyncWrapper(async (req, res, next) => {
    const medicineName = req.query.name;
    let {language} = req.query;
    language = language || 'arabic';
    const genAI = configureGemini();
    const model = genAI.getGenerativeModel({ 
        model: "gemini-2.5-flash-preview-05-20",
        systemInstruction: {
            parts: [
                {
                    text: `you will be given a medicine name and you have to
                            get list of alternative medicine names, description, dosage info, list of side effects and list of active ingredients for given medicine name.
                            write description, dosage info, side effects in ${language} and the rest of the keys in english.
                            and return them in json format with keys 
                            alternative_medicines: [alternative_medicines], 
                            description: description,
                            dosage_info: dosage_info,
                            side_effects: [side_effects],
                            active_ingredients: [active_ingredients]
                            if medicine name is not correct return json contains this fields
                            {
                                error: error
                            }
                            and response in ${language} language
                            `,
                },
            ]
        }
    }); 
    const chat = model.startChat();
    const result = await chat.sendMessage(medicineName);
    const response = await result.response;
    const generatedText = response.text();
    let cleanedText = generatedText.replace(/\*/g, "");
    cleanedText = cleanedText.slice(7, -3);
    const jsonObject = JSON.parse(cleanedText);
    if (jsonObject.error) {
        res.status(400).json({ status: httpStatusText.FAIL, data:{error: jsonObject.error} });
    }
    return res.status(200).json({ status: httpStatusText.SUCCESS, data:{response: jsonObject} });
    
});



module.exports = {
    createMedicine,
    getAllMedicines,
    getMedicineById,
    updateMedicine,
    deleteMedicine,
    autoComplete,
    getMedicineInfo
}; 