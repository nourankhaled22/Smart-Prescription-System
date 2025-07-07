const express = require('express');
const app = new express();
const mongoose = require('mongoose');
const cors = require('cors');
app.use(cors());
require('dotenv').config();
app.use(express.json())   // Middleware to parse JSON request body
mongoose.connect(process.env.URL);
const httpStatusText = require('./utils/httpStatusText');
const path = require('path');
const authRoutes = require('./routes/AuthRoutes');
const doctorRoutes = require('./routes/DoctorRoutes');
const patientRoutes = require('./routes/PatientRoutes');
const allergyRoutes = require('./routes/AllergyRoutes');
const vaccineRoutes = require('./routes/vaccineRoutes');
const bloodPressureRoutes = require('./routes/BloodPressureRoutes');
const chronicDiseaseRoutes = require('./routes/ChronicDiseaseRoutes');
const medicineRoutes = require('./routes/MedicineRoutes');
const examinationRoutes = require('./routes/ExaminationRoutes');
const prescriptionRoutes = require('./routes/PrescriptionRoutes');
const HistoryRoutes = require('./routes/HistoryRoutes');
const ChatbotRoutes = require('./routes/ChatbotRoutes');
const HistorySummaryRoutes = require('./routes/HistorySummaryRoutes');
const ScanPrescriptionRoutes = require('./routes/ScanPrescriptionRoutes');
const ScanMedicineRoutes = require('./routes/ScanMedicineRoutes');

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/api/auth', authRoutes); 
app.use('/api/doctor', doctorRoutes); 
app.use('/api/patient', patientRoutes);
app.use('/api/allergy', allergyRoutes);
app.use('/api/vaccine', vaccineRoutes);
app.use('/api/blood-pressure', bloodPressureRoutes);
app.use('/api/chronic-disease', chronicDiseaseRoutes);
app.use('/api/medicine', medicineRoutes);
app.use('/api/examination', examinationRoutes);
app.use('/api/prescription', prescriptionRoutes);
app.use('/api/history', HistoryRoutes);
app.use('/api/chatbot', ChatbotRoutes);
app.use('/api/history-summary', HistorySummaryRoutes)
app.use('/api/scan-prescription', ScanPrescriptionRoutes)
app.use('/api/scan-medicine', ScanMedicineRoutes)

////////////////////////////////////////////


// Middleware to parse URL-encoded data
app.use(express.urlencoded({ extended: true }));

// const getAllRedisData = require('./getRedisData');
// getAllRedisData();          

// global middleware for not found router
// app.all('*', (req, res, next)=> {
//     return res.status(404).json({ status: httpStatusText.ERROR, message: 'this resource is not available'})
// })    

// global error handler
app.use((error, req, res, next) => {
    if (error.name === 'ValidationError') {
        res.status(400).json({status: httpStatusText.FAIL, message: error.message, code: 400, data: null});
    }
    res.status(error.statusCode || 500).json({status: error.statusText || httpStatusText.ERROR, message: error.message, code: error.statusCode || 500, data: null});
})


////////////////////////////////////////////////////////////////////////////////////////
app.listen(process.env.PORT, () => {
    console.log(`🚀 Server running on http://localhost:${process.env.PORT}`);
});

// run -> npm run run
