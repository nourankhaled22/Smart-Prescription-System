const mongoose = require('mongoose');

const prescriptionSchema = new mongoose.Schema({
    nationalId: {
        type: String,
        required: true,
        trim: true,
    },

    doctorName: {
        type: String,
        trim: true
    },

    doctorId: {
        type: mongoose.Schema.Types.ObjectId
    },

    specialization: {
        type: String,
        trim: true
    },

    clinicAddress: {
        type: String,
        trim: true
    },

    clinicPhoneNumber: {
        type: String,
        trim: true
    },

    medicines: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Medicine'
    }],

    examinations: [{
        type: String,
        trim: true
    }],

    diagnoses: [{
        type: String,
        trim: true
    }],

    notes: {
        type: String,
        trim: true
    },

    date: {
        type: Date,
        default: new Date(Date.now() + 3 * 60 * 60 * 1000)
    },
    
    }, {
    timestamps: true
});

const Prescription = mongoose.model('Prescription', prescriptionSchema);
module.exports = Prescription;
