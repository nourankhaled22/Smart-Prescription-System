const Allergy = require('../models/Allergy');
const Medicine = require('../models/Medicine');
const Vaccine = require ('../models/Vaccine');
const ChronicDisease = require('../models/ChronicDisease');
const BloodPressure = require('../models/BloodPressure');
const asyncWrapper = require('../middleware/asyncWrapper');
const configureGemini = require("../config/ai-config");
const httpStatusText = require('../utils/httpStatusText');

const getHistorySummary = asyncWrapper(async (req, res, next) => {
    const nationalId = req.currentUser.nationalId;
    let {language} = req.query;
    language = language || 'arabic';
    const allergies = await Allergy.find({nationalId: nationalId}, 'allergyName -_id');    
    const medicines = await Medicine.find({nationalId: nationalId}, 'medicineName -_id');
    const vaccines = await Vaccine.find({nationalId: nationalId}, 'vaccineName -_id');
    const chronicDiseases = await ChronicDisease.find({nationalId: nationalId}, 'diseaseName -_id');
    const bloodPressures = await BloodPressure.find({nationalId: nationalId}, 'pulse diastolic systolic -_id');
    const history = {
        allergies: allergies,
        medicines: medicines,
        vaccines: vaccines,
        chronicDiseases: chronicDiseases,
        bloodPressures: bloodPressures
    }

    const genAI = configureGemini();
    const model = genAI.getGenerativeModel({ 
        model: "gemini-2.5-flash-preview-05-20",
        systemInstruction: {
            parts: [
                {
                    text: `i will send you a patient history in json format and i want you to summarize the patient history and give me a summary of the patient history.
                    you must only response with json format with following keys: 
                    {   
                        health_summary: "string"
                        tips_and_guides: [tips_and_guides]
                        current_medicines:[{
                            medicine_name: "string",
                            info: "string"                       
                        }]
                        general_advices_about_medicines: [general_advices_about_medicines]
                        manage_blood_pressure: "string"
                        information_about_each_vaccine:[{
                            vaccine_name: "string",
                            info: "string"
                        }]
                        information_about_each_allergy:[{
                            allergy_name: "string",
                            info: "string"
                        }]
                    }
                    write information about each allergy, vaccine, medicine, chronic disease, blood pressure.
                    and response in ${language} language
                    if history does not contain any information return json contains this fields
                    {
                        error: 'write error in ${language} language'
                    }`
                },
            ]
        }
    }); 
    const chat = model.startChat();

    const result = await chat.sendMessage(JSON.stringify(history));
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
    getHistorySummary
}


