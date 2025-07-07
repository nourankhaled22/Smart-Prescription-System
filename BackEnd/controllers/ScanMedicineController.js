const extractMedicineName = require('../utils/extractMedicineName');
const asyncWrapper = require("../middleware/asyncWrapper");
const Medicine = require('../models/Medicine');
const httpStatusText = require('../utils/httpStatusText');
const cloudinary = require('../config/cloudinaryConfig');
const appError = require('../utils/appError');

const ScanMedicine = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    if (!req.file) {
        const error = appError.create('medicine image is required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const medicineUrl = req.file.path;
    const text = await extractMedicineName(medicineUrl);
    cleanedText = text.slice(7, -3);
    const jsonObject = JSON.parse(cleanedText);
    // unlink the file
    await cloudinary.uploader.destroy(req.file.filename);
    if (jsonObject.error) {
        res.status(400).json({ status: httpStatusText.FAIL, data:{error: jsonObject.error} });
    }
    // save medicines
    const newMed = new Medicine({
            nationalId,
            medicineName: jsonObject.medicine_name
    })
    await newMed.save();
    res.status(200).json({ status: httpStatusText.SUCCESS, data:{medicine: newMed} });
});

module.exports = { ScanMedicine };