const asyncWrapper = require('../middleware/asyncWrapper');
const httpStatusText = require('../utils/httpStatusText');  
const Allergy = require('../models/Allergy');
const Medicine = require('../models/Medicine');
const Vaccine = require('../models/Vaccine');
const BloodPressure = require('../models/BloodPressure');
const ChronicDisease = require('../models/ChronicDisease');
const Examination = require('../models/Examination');
const Prescription = require('../models/Prescription');
const Patient = require('../models/Patient');

const getHistory = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId || req.currentPatient.nationalId;
    const allergies = await Allergy.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});    
    const medicines = await Medicine.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    const vaccines = await Vaccine.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    const prescriptions = await Prescription.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    const chronicDiseases = await ChronicDisease.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    const bloodPressures = await BloodPressure.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    const examinations = await Examination.find({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false});
    const patient = await Patient.findOne({nationalId: nationalId}, {"__v":false, "createdAt":false, "updatedAt":false, "password": false, "chats": false});
    res.status(200).json({status: httpStatusText.SUCCESS, 
        data: {
            history: {
                allergies: allergies, 
                medicines: medicines, 
                vaccines: vaccines, 
                prescriptions: prescriptions,
                chronicDiseases: chronicDiseases,
                bloodPressures: bloodPressures,
                examinations: examinations
            },
            patient: {
                firstName: patient.firstName,
                lastName: patient.lastName,
                dateOfBirth: patient.dateOfBirth,
                phoneNumber: patient.phoneNumber,
                _id: patient._id
            }
        }});
});

module.exports = {
    getHistory
}