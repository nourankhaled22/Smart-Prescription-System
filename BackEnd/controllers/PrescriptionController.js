const Prescription = require('../models/Prescription');
const asyncWrapper = require('../middleware/asyncWrapper');
const httpStatusText = require('../utils/httpStatusText'); 
const appError = require('../utils/appError');
const Medicine = require('../models/Medicine');
const Doctor = require('../models/Doctor');
const Patient = require('../models/Patient');

const addPrescription = asyncWrapper(async (req, res, next) => {
    const {medicines, examinations, diagnoses, notes, date} = req.body;
    const nationalId = req.currentPatient.nationalId;
    const doctorId = req.currentUser.id;
    const doctor = await Doctor.findById(doctorId);
    if (!doctor) {
        const error = appError.create('Doctor not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    const savedMedicineIds = []
    // save each medicine in table
    for (const med of medicines) {
        const newMed = new Medicine({
            nationalId,
            ...med
        })
        await newMed.save();
        savedMedicineIds.push(newMed._id);
    }
    const newPrescription = new Prescription({
        nationalId,
        doctorId,
        doctorName: doctor.firstName + " " + doctor.lastName,
        clinicPhoneNumber: doctor.phoneNumber,
        specialization: doctor.specialization,
        clinicAddress: doctor.clinicAddress,
        medicines: savedMedicineIds,
        examinations,
        diagnoses,
        notes,
        date
    })
    await newPrescription.save();
    const prescription = await Prescription.findById(newPrescription._id).populate({path: "medicines", select: "-createdAt -updatedAt -__v"});
    const prescriptionObject = prescription.toObject();
    delete prescriptionObject.__v;
    delete prescriptionObject.createdAt;
    delete prescriptionObject.updatedAt;
    return res.status(201).json({status: httpStatusText.SUCCESS, data:{prescription: prescriptionObject}});
});

const getAllPrescriptions = asyncWrapper(async (req, res, next) => {
    const role = req.currentUser.role;
    if (role === "patient") {
        const nationalId = req.currentUser.nationalId;
        const prescriptions = await Prescription.find({nationalId}, {"__v":false, "createdAt":false, "updatedAt":false}).populate({path: "medicines", select: "-createdAt -updatedAt -__v"});
        res.status(200).json({status: httpStatusText.SUCCESS, data:{prescriptions: prescriptions}});
    }
    if (role === "doctor") {
        const doctorId = req.currentUser.id;
        const prescriptions = await Prescription.find({doctorId}, {"notes":true, "date":true, "nationalId":true});
        const responses = [];
        for (const prescription of prescriptions) {
            const patient = await Patient.findOne({nationalId: prescription.nationalId}, {"firstName":true, "lastName":true, "dateOfBirth":true});
            responses.push({
                nationalId: prescription.nationalId,
                patientName: patient.firstName + " " + patient.lastName,
                dateOfBirth: patient.dateOfBirth,
                notes: prescription.notes,
                date: prescription.date
            });
        }
        res.status(200).json({status: httpStatusText.SUCCESS, data:{prescriptions: responses}});
    }   
});

const getPrescriptionById = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const role = req.currentUser.role;
    const prescription = await Prescription.findById(id, {"__v":false, "createdAt":false, "updatedAt":false}).populate({path: "medicines", select: "-createdAt -updatedAt -__v"});
    if (!prescription) {
        const error = appError.create('Prescription not found', 404, httpStatusText.FAIL);
        return next(error);
    }

    if ( (role === "patient" && req.currentUser.nationalId !== prescription.nationalId) ||
        (role === "doctor" && req.currentPatient.nationalId !== prescription.nationalId) )
    {
        const error = appError.create('You are not authorized to view this prescription', 401, httpStatusText.FAIL);
        return next(error);
    }
    res.status(200).json({status: httpStatusText.SUCCESS, data:{prescription: prescription}});
});

const deletePrescription = asyncWrapper(async (req, res, next) => {
    const {id} = req.params;
    const prescription = await Prescription.findById(id);
    if (!prescription) {
        const error = appError.create('Prescription not found', 404, httpStatusText.FAIL);
        return next(error);
    }
    if (prescription.nationalId !== req.currentUser.nationalId) {
        const error = appError.create('You are not authorized to delete this prescription', 401, httpStatusText.FAIL);
        return next(error);
    }
    const deletedPrescription = await Prescription.findByIdAndDelete(id);
    return res.status(200).json({status: httpStatusText.SUCCESS, data: null});
});

module.exports = {
    addPrescription,
    getAllPrescriptions,
    getPrescriptionById,
    deletePrescription,
}