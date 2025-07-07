const extractTextFromPrescription = require('../utils/extractTextFromPrescription');
const asyncWrapper = require("../middleware/asyncWrapper");
const Medicine = require('../models/Medicine');
const Prescription = require('../models/Prescription');
const httpStatusText = require('../utils/httpStatusText');
const cloudinary = require('../config/cloudinaryConfig');
const appError = require('../utils/appError');
const Patient = require('../models/Patient');

const ScanPrescription = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    // const patient = await Patient.findOne({nationalId});
    if (!req.file) {
        const error = appError.create('prescription is required', 400, httpStatusText.FAIL)
        return next(error);
    }
    const prescriptionUrl = req.file.path;
    const text = await extractTextFromPrescription(prescriptionUrl);
    cleanedText = text.slice(7, -3);
    const jsonObject = JSON.parse(cleanedText);
    // unlink the file
    await cloudinary.uploader.destroy(req.file.filename);
    if (jsonObject.error) {
        res.status(400).json({ status: httpStatusText.FAIL, data:{error: jsonObject.error} });
    }
    const savedMedicineIds = [];
    // save medicines
    for (const med of jsonObject.medicines) {
        const newMed = new Medicine({
            nationalId,
            medicineName: med
        })
        await newMed.save();
        savedMedicineIds.push(newMed._id);
    }
    // save prescription
    const newPrescription = new Prescription({
        nationalId: nationalId,
        // patientName: patient.firstName + " " + patient.lastName,
        // dateOfBirth: patient.dateOfBirth,
        doctorName: jsonObject.doctor_name,
        specialization: jsonObject.specialization,
        medicines: savedMedicineIds,
    })
    await newPrescription.save();
    const prescription = await Prescription.findById(newPrescription._id, {"__v":false, "createdAt":false, "updatedAt":false}).populate({path: "medicines", select: "-createdAt -updatedAt -__v" });
    res.status(200).json({ status: httpStatusText.SUCCESS, data:{prescription: prescription} });
});

module.exports = { ScanPrescription };